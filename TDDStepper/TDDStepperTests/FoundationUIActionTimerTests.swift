//
//  FoundationUIActionTimerTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest
@testable import TDDStepper

final class FoundationUIActionTimer: UIActionTimer {
    struct TimerSpecs {
        let timeInterval: TimeInterval
        let repeats: Bool
        
        static func `default`() -> TimerSpecs {
            TimerSpecs(timeInterval: 1, repeats: true)
        }
    }
    
    private(set) var timer: Timer?
    let specs: TimerSpecs
    
    init(specs: TimerSpecs = .default()) {
        self.specs = specs
    }
    
    func schedule(action: @escaping (any UIActionTimer) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: specs.timeInterval, repeats: specs.repeats, block: { [self] _ in
            action(self)
        })
    }
    
    func invalidate() {}
}

class FoundationUIActionTimerTests: XCTestCase {
    func test_init_doesNotSchduleTimer() {
        let sut = FoundationUIActionTimer()
        XCTAssertNil(sut.timer)
    }
    
    func test_initWithDefaultSpecs() {
        let sut = FoundationUIActionTimer()
        XCTAssertEqual(sut.specs.timeInterval, 1)
        XCTAssertTrue(sut.specs.repeats)
    }
    
    func test_schedule_schedulesTimerWithSpecs() {
        let specs = FoundationUIActionTimer.TimerSpecs(timeInterval: 0.5, repeats: true)
        let sut = FoundationUIActionTimer(specs: specs)
        
        sut.schedule(action: { _ in })
        
        XCTAssertEqual(sut.timer?.timeInterval, specs.timeInterval)
    }
}
