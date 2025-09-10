//
//  StepperButtonTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 5.09.2025.
//

import XCTest
@testable import TDDStepper

class StepperButtonTests: XCTestCase {
    func test_sendsEvent_uponTap() {
        var eventCount = 0
        let sut = StepperButton()
        sut.addAction(UIAction(handler: { _ in eventCount += 1 }), for: .touchUpInside)
        
        sut.simulateTap()
        XCTAssertEqual(eventCount, 1)
    }
    
    func test_schedulesTimer_uponTouch() {
        let (sut, timer) = makeSUT()
        
        sut.simulateTouchStart()
        XCTAssertTrue(timer.isScheduled)
    }
    
    func test_touchStart_doesNotScheduleTimerWhenButtonIsNonContinuous() {
        let (sut, timer) = makeSUT(isContinuous: false)
        
        sut.simulateTouchStart()
        XCTAssertFalse(timer.isScheduled)
    }
    
    func test_sendsEvent_whenTimerFires() {
        var eventCount = 0
        let (sut, timer) = makeSUT()
        sut.addAction(UIAction(handler: { _ in eventCount += 1}), for: .touchUpInside)
        sut.simulateTouchStart()
        
        timer.fire()
        XCTAssertEqual(eventCount, 1)
        
        timer.fire()
        XCTAssertEqual(eventCount, 2)
    }
    
    func test_doesNotSendEvent_whenTimerFiresAfterTouchEnds() {
        var eventCount = 0
        let (sut, timer) = makeSUT()
        sut.addAction(UIAction(handler: { _ in eventCount += 1}), for: .touchUpInside)
        sut.simulateTouchStart()
        
        timer.fire()
        XCTAssertEqual(eventCount, 1)
        
        sut.simulateTouchEnd()
        timer.fire()
        XCTAssertEqual(eventCount, 1, "Expected not to receive any events after touch ended")
    }
    
    func test_sendsEventWhenTapOccurs_afterTouchEnds() {
        var eventCount = 0
        let (sut, timer) = makeSUT()
        sut.addAction(UIAction(handler: { _ in eventCount += 1}), for: .touchUpInside)
        sut.simulateTouchStart()
        
        timer.fire()
        XCTAssertEqual(eventCount, 1)
        
        sut.simulateTouchEnd()
        timer.fire()
        XCTAssertEqual(eventCount, 1, "Expected not to receive any events after touch ended")
        
        sut.simulateTap()
        XCTAssertEqual(eventCount, 2, "Expected to receive an event when tap occurs")
    }
    
    func test_isHighlighted_stateChanges() {
        let (sut, _) = makeSUT()
        XCTAssertFalse(sut.isHighlighted, "Precondition")
        
        sut.simulateTouchStart()
        XCTAssertTrue(sut.isHighlighted)
        
        sut.simulateTouchEnd()
        XCTAssertFalse(sut.isHighlighted)
        
        sut.simulateTouchStart()
        XCTAssertTrue(sut.isHighlighted)
    }
    
    func test_isEnabled_effectsIsHighlighted() {
        let (sut, _) = makeSUT()
        
        sut.simulateTouchStart()
        XCTAssertTrue(sut.isHighlighted, "Expected highlight after touch begins")
        
        sut.isEnabled = false
        XCTAssertFalse(sut.isHighlighted, "Expected not to remain highlighted once the button is disabled during touch")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(isContinuous: Bool = true, file: StaticString = #filePath, line: UInt = #line) -> (sut: StepperButton, timer: TimerSpy) {
        let timer = TimerSpy()
        let sut = StepperButton(continuation: UIActionContinuation(timer: timer))
        sut.isContinuous = isContinuous
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Expected instance to be nil. Potential memory leak.", file: file, line: line)
        }
        return (sut, timer)
    }
    
    private class TimerSpy: NSObject, UIActionTimer {
        private var action: ((UIActionTimer) -> Void)?
        var isScheduled: Bool {
            action != nil
        }
        
        func schedule(action: @escaping (UIActionTimer) -> Void) {
            self.action = action
        }
        
        func invalidate() {
            action = nil
        }
        
        func fire() {
            action?(self)
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
        touchesBegan([], with: nil)
        touchesEnded([], with: nil)
    }
}
