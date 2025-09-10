import UIKit
import XCTest

// MARK: - XCTestCase
extension XCTestCase {
    func record(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true)
            try snapshotData?.write(to: snapshotURL)
            XCTFail("Record succeeded - Use the `assert` to compare the snapshot from now on", file: file, line: line)
        } catch {
            XCTFail("Failed to record snapshot data with error: \(error)", file: file, line: line)
        }
    }
    
    func assert(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            return XCTFail("Failed to load stored snapshot at URL: \(snapshot). Use the `record` method to store a snapshot before asserting.")
        }
        
        if snapshotData != storedSnapshotData {
            let temporarySnapshotURL = URL(filePath: NSTemporaryDirectory(), directoryHint: .isDirectory)
                .appending(path: snapshotURL.lastPathComponent)
            
            try? snapshotData?.write(to: temporarySnapshotURL)
            
            XCTFail("New snapshot does not match with stored snapshot. New snapshot URL: \(temporarySnapshotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }
    
    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        URL(filePath: String(describing: file))
            .deletingLastPathComponent()
            .appending(path: "snapshots")
            .appending(path: "\(name).png")
    }
    
    private func makeSnapshotData(for snapshot: UIImage, file: StaticString, line: UInt) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PND data representation from snapshot", file: file, line: line)
            return nil
        }
        
        return data
    }
}

// MARK: - Snapshot
extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}

extension UIView {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        let container = UIViewController()
        container.view.addSubview(self)
        container.view.backgroundColor = configuration.traitCollection.userInterfaceStyle == .light ? .white : .black
        return SnapshotWindow(configuration: configuration, root: container).snapshot()
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection
    
    static func iPhone15(style: UIUserInterfaceStyle = .light, layoutDirection: UITraitEnvironmentLayoutDirection = .leftToRight, contentSizeCategory: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        SnapshotConfiguration(
            size: CGSize(width: 393, height: 852),
            safeAreaInsets: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = layoutDirection
                traits.preferredContentSizeCategory = contentSizeCategory
                traits.userInterfaceIdiom = .phone
                traits.horizontalSizeClass = .compact
                traits.verticalSizeClass = .regular
                traits.displayScale = 3
                traits.displayGamut = .P3
                traits.userInterfaceStyle = style
            })
        )
    }
    
    static func anyDevice(size: CGSize, style: UIUserInterfaceStyle = .light, layoutDirection: UITraitEnvironmentLayoutDirection = .leftToRight, contentSizeCategory: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        SnapshotConfiguration(
            size: size,
            safeAreaInsets: .zero,
            layoutMargins: .zero,
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = layoutDirection
                traits.preferredContentSizeCategory = contentSizeCategory
                traits.userInterfaceIdiom = .phone
                traits.horizontalSizeClass = .compact
                traits.verticalSizeClass = .regular
                traits.displayScale = 3
                traits.displayGamut = .P3
                traits.userInterfaceStyle = style
            })
        )
    }
}

private final class SnapshotWindow: UIWindow {
    private var configuration = SnapshotConfiguration.iPhone15(style: .light)
    
    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.layoutMargins = configuration.layoutMargins
        self.rootViewController = root
        self.isHidden = false
        root.view.layoutMargins = configuration.layoutMargins
    }
    
    override var safeAreaInsets: UIEdgeInsets {
        configuration.safeAreaInsets
    }
    
    override var traitCollection: UITraitCollection {
        configuration.traitCollection
    }
    
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { ctx in
            layer.render(in: ctx.cgContext)
        }
    }
}
