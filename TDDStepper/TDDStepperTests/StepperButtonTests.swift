//
//  StepperButtonTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 5.09.2025.
//

import XCTest
@testable import TDDStepper

class StepperButtonTests: XCTestCase {
    private var timer: TimerSpy?
    
    func test_sendsEvent_whenTouchEnds() {
        var eventCount = 0
        let sut = StepperButton()
        sut.addAction(UIAction(handler: { _ in eventCount += 1 }), for: .touchUpInside)
        
        sut.simulateTap()
        XCTAssertEqual(eventCount, 1)
    }
    
    func test_requestsTimer_whenTouchStarts() {
        let sut = makeSUT()
        
        sut.simulateTouchStart()
        XCTAssertNotNil(timer)
    }
    
    func test_sendsEvent_whenTimerFires() {
        var eventCount = 0
        let sut = makeSUT()
        sut.addAction(UIAction(handler: { _ in eventCount += 1}), for: .touchUpInside)
        sut.simulateTouchStart()
        
        timer?.fire()
        XCTAssertEqual(eventCount, 1)
        
        timer?.fire()
        XCTAssertEqual(eventCount, 2)
    }
    
    func test_doesNotSendsEvent_whenTouchEndsAndTimerFires() {
        var eventCount = 0
        let sut = makeSUT()
        sut.addAction(UIAction(handler: { _ in eventCount += 1}), for: .touchUpInside)
        sut.simulateTouchStart()
        
        timer?.fire()
        XCTAssertEqual(eventCount, 1)
        
        sut.simulateTouchEnd()
        timer?.fire()
        XCTAssertEqual(eventCount, 1, "Expected not to receive any events after touch ends")
    }
    
    func test_sendsEventWhenSecondTapHappens_afterContinuation() {
        var eventCount = 0
        let sut = makeSUT()
        sut.addAction(UIAction(handler: { _ in eventCount += 1}), for: .touchUpInside)
        sut.simulateTouchStart()
        
        timer?.fire()
        XCTAssertEqual(eventCount, 1)
        
        sut.simulateTouchEnd()
        timer?.fire()
        XCTAssertEqual(eventCount, 1, "Expected not to receive any events after touch ends")
        
        sut.simulateTap()
        XCTAssertEqual(eventCount, 2, "Expected to receive event when tap happens")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> StepperButton {
        let sut = StepperButton(timerProvider: { [self] callback in
            timer = TimerSpy(block: callback)
            return timer!
        })
        return sut
    }
    
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
    
    func simulateTouchEnd() {
        touchesEnded([], with: nil)
    }
    
    func simulateTap() {
        touchesEnded([], with: nil)
    }
}
