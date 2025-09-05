//
//  StepperButtonTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 5.09.2025.
//

import XCTest
@testable import TDDStepper

class StepperButtonTests: XCTestCase {
    func test_sendsEvent_whenTouchEnds() {
        var eventCount = 0
        let sut = StepperButton()
        sut.addAction(UIAction(handler: { _ in eventCount += 1 }), for: .touchUpInside)
        
        sut.simulateTap()
        XCTAssertEqual(eventCount, 1)
    }
    
    func test_requestsTimer_whenTouchStarts() {
        var timer: TimerSpy?
        let sut = StepperButton(timerProvider: { callback in
            timer = TimerSpy(block: callback)
            return timer!
        })
        
        sut.simulateTouchStart()
        XCTAssertNotNil(timer)
    }
    
    // MARK: - Helpers
    private class TimerSpy: Timer {
        private var block: (() -> Void)?
        
        convenience init(block: @escaping () -> Void) {
            self.init()
            self.block = block
        }
        
        override func fire() {
            block?()
        }
        
        override func invalidate() {
            block = nil
        }
    }
}

extension StepperButton {
    func simulateTouchStart() {
        touchesBegan([], with: nil)
    }
    
    func simulateTap() {
        touchesEnded([], with: nil)
    }
}
