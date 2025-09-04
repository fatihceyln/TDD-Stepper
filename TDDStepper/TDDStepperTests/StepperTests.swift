//
//  StepperTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 4.09.2025.
//

import XCTest

class Stepper: UIControl {
    var value: UInt = 0 {
        didSet {
            if value > maximumValue {
                value = maximumValue
            }
            
            if value < minimumValue {
                value = minimumValue
            }
            
            textLabel.text = String(value)
            updateButtons()
            sendActions(for: .valueChanged)
        }
    }
    
    var minimumValue: UInt = 0 {
        didSet {
            if minimumValue > value {
                value = minimumValue
            }
            
            if minimumValue > maximumValue {
                maximumValue = minimumValue
            }
        }
    }
    
    var maximumValue: UInt = 10 {
        didSet {
            if maximumValue < minimumValue {
                minimumValue = maximumValue
            }
        }
    }
    
    var stepValue: UInt = 1
    
    private(set) lazy var decrementButton = makeButton(title: "-", actionHandler: handleDecrementButtonTap())
    private(set) lazy var incrementButton = makeButton(title: "+", actionHandler: handleIncrementButtonTap())
    private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private lazy var borderLayer: CAShapeLayer = {
        let borderLayer = CAShapeLayer()
        borderLayer.fillColor = UIColor.white.cgColor
        borderLayer.borderWidth = 1
        borderLayer.borderColor = nil
        borderLayer.strokeColor = UIColor.systemGray5.cgColor
        layer.insertSublayer(borderLayer, at: 0)
        return borderLayer
    }()
    
    convenience init() {
        self.init(frame: .zero)
        
        textLabel.text = String(value)
        updateButtons()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: bounds.inset(by: UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)), cornerRadius: 18).cgPath
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let fittingSize = systemLayoutSizeFitting(CGSize(width: -1, height: 50), withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
        return fittingSize
    }
    
    private func updateButtons() {
        func backgroundColor(for button: UIButton) -> UIColor {
            button.isEnabled ? .systemGray5 : .systemGray6
        }
        
        decrementButton.isEnabled = value > minimumValue
        incrementButton.isEnabled = value < maximumValue
        
        decrementButton.backgroundColor = backgroundColor(for: decrementButton)
        incrementButton.backgroundColor = backgroundColor(for: incrementButton)
    }
    
    private func handleIncrementButtonTap() -> () -> Void {
        { [unowned self] in
            value += stepValue
        }
    }
    
    private func handleDecrementButtonTap() -> () -> Void {
        { [unowned self] in
            let nextValue: Int = Int(value) - Int(stepValue)
            
            if nextValue < 0 {
                value = .zero
            } else {
                value = UInt(nextValue)
            }
        }
    }
}

extension Stepper {
    private func setupConstraints() {
        addSubview(decrementButton)
        addSubview(textLabel)
        addSubview(incrementButton)
        
        [decrementButton, textLabel, incrementButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            decrementButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            decrementButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            decrementButton.widthAnchor.constraint(equalToConstant: 32),
            decrementButton.heightAnchor.constraint(equalToConstant: 32),
            
            textLabel.leadingAnchor.constraint(equalTo: decrementButton.trailingAnchor, constant: 4),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: incrementButton.leadingAnchor, constant: -4),
            
            incrementButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            incrementButton.widthAnchor.constraint(equalToConstant: 32),
            incrementButton.heightAnchor.constraint(equalToConstant: 32),
            incrementButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func makeButton(title: String, actionHandler: @escaping () -> Void) -> UIButton {
        let button = UIButton(frame: .zero)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.label, .font: UIFont.preferredFont(forTextStyle: .subheadline)]), for: .normal)
        button.addAction(UIAction(handler: { _ in actionHandler() }), for: .touchUpInside)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 16
        return button
    }
}

class StepperTests: XCTestCase {
    // MARK: - Behavior tests
    func test_defaultValues() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.value, 0, "Default value")
        XCTAssertEqual(sut.minimumValue, 0, "Default minimum value")
        XCTAssertEqual(sut.maximumValue, 10, "Default maximum value")
        XCTAssertEqual(sut.stepValue, 1, "Default step value")
    }
    
    func test_setMinimumValueBeyondValue_matchesValueWithMinimumValue() {
        let sut = makeSUT()
        sut.value = 1
        
        sut.minimumValue = 5
        
        XCTAssertEqual(sut.value, 5, "Expected value to be equal with minimum value")
    }
    
    func test_setMinimumValueBeyonMaximumValue_matchesMaximumValueWithMinimum() {
        let sut = makeSUT()
        sut.maximumValue = 1
        
        sut.minimumValue = 20
        
        XCTAssertEqual(sut.maximumValue, 20, "Expected maximum value to be equal with minimum value")
    }
    
    func test_setMaximumValueBelowMinimumValue_matchesMinimumValueWithMaximum() {
        let sut = makeSUT()
        sut.minimumValue = 5
        
        sut.maximumValue = 1
        
        XCTAssertEqual(sut.minimumValue, 1, "Expected minimum value to be equal with maximum value")
    }
    
    func test_setValueBeyondMaximum_limitsValueToMaximum() {
        let sut = makeSUT()
        sut.maximumValue = 5
        
        sut.value = 10
        
        XCTAssertEqual(sut.value, 5, "Expected value to be limited by maximum value")
    }
    
    func test_setValueBelowMinimum_limitsValueToMinimum() {
        let sut = makeSUT()
        sut.minimumValue = 3
        
        sut.value = 1
        
        XCTAssertEqual(sut.value, 3, "Expected value to be limited by minimum value")
    }
    
    func test_sendsValueChangedEvent_whenValueChanges() {
        var eventCount = 0
        let sut = makeSUT()
        sut.addAction(UIAction(handler: { _ in eventCount += 1 }), for: .valueChanged)
        
        sut.value = 1
        XCTAssertEqual(eventCount, 1)
        
        sut.simulateTapOnIncrementButton()
        XCTAssertEqual(eventCount, 2)
        
        sut.simulateTapOnDecrementButton()
        XCTAssertEqual(eventCount, 3)
    }
    
    // MARK: - Button Tests
    
    func test_incrementButtonTap_increasesValue() {
        let sut = makeSUT()
        sut.maximumValue = 10
        sut.value = 0
        
        sut.simulateTapOnIncrementButton()
        
        XCTAssertEqual(sut.value, 1, "Expected value to be increased")
    }
    
    func test_incrementButtonTap_increasesValueByStepValue() {
        let sut = makeSUT()
        sut.maximumValue = 10
        sut.value = 0
        sut.stepValue = 5
        
        sut.simulateTapOnIncrementButton()
        
        XCTAssertEqual(sut.value, 5, "Expected value to be increased by step value")
    }
    
    func test_decrementButtonTap_decrementsValue() {
        let sut = makeSUT()
        sut.maximumValue = 10
        sut.value = 3
        
        sut.simulateTapOnDecrementButton()
        
        XCTAssertEqual(sut.value, 2, "Expected value to be decreased")
    }
    
    func test_decrementButtonTap_decrementsValueByStepValue() {
        let sut = makeSUT()
        sut.maximumValue = 10
        sut.value = 10
        sut.stepValue = 5
        
        sut.simulateTapOnDecrementButton()
        
        XCTAssertEqual(sut.value, 5, "Expected value to be decreased by step value")
    }
    
    func test_decrementButtonTap_doesNotDecrementsValueToNegative() {
        let sut = makeSUT()
        sut.minimumValue = 0
        sut.value = 0
        
        sut.simulateTapOnDecrementButton()
        XCTAssertEqual(sut.value, 0, "Expected not to change value")
        
        sut.value = 2
        sut.stepValue = 3
        sut.simulateTapOnDecrementButton()
        XCTAssertEqual(sut.value, 0, "Expected value to be zero")
    }
    
    // MARK: - Label Tests
    func test_textLabel_rendersValue() {
        let sut = makeSUT()
        XCTAssertEqual(sut.textLabel.text, String(sut.value), "Default value")
        
        sut.value = 1
        XCTAssertEqual(sut.textLabel.text, "1")
        
        sut.simulateTapOnIncrementButton()
        XCTAssertEqual(sut.textLabel.text, "2")
        
        sut.simulateTapOnDecrementButton()
        XCTAssertEqual(sut.textLabel.text, "1")
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> Stepper {
        let sut = Stepper()
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Expected sut to be nil. Potential memory leak.", file: file, line: line)
        }
        return sut
    }
}

private extension Stepper {
    func simulateTapOnIncrementButton() {
        incrementButton.sendActions(for: .touchUpInside)
    }
    
    func simulateTapOnDecrementButton() {
        decrementButton.sendActions(for: .touchUpInside)
    }
}
