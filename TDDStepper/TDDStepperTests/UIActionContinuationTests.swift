//
//  UIActionContinuationTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest
@testable import TDDStepper

class UIActionContinuationTests: XCTestCase {
    func test_init_doesNotScheduleTimer() {
        let (_, timer) = makeSUT()
        
        XCTAssertFalse(timer.isScheduled, "Expected timer to be not scheduled upon creation")
    }
    
    func test_schedule_schedulesTimer() {
        let (sut, timer) = makeSUT()
        
        sut.schedule {}
        
        XCTAssertTrue(timer.isScheduled, "Expected timer to be scheduled after schedule command")
    }
    
    func test_schedule_notifiesHandlerWhenTimerFires() {
        var eventCount = 0
        let (sut, timer) = makeSUT()
        
        sut.schedule { eventCount += 1 }
        timer.fire()
        XCTAssertEqual(eventCount, 1, "Expected to receive an event when timer fires")
        
        timer.fire()
        XCTAssertEqual(eventCount, 2, "Expected to receive another event when timer fires again")
    }
    
    func test_invalidateAfterSchedule_doesNotNotifyHandlerWhenTimerFires() {
        var eventCount = 0
        let (sut, timer) = makeSUT()
        
        sut.schedule { eventCount += 1 }
        timer.fire()
        XCTAssertEqual(eventCount, 1, "Expected to receive an event when timer fires")
        
        sut.invalidate()
        timer.fire()
        XCTAssertEqual(eventCount, 1, "Expected not to receive another event when continuation is invalidated and timer fires")
    }
    
    func test_isContinuing_stateChanges() {
        let (sut, timer) = makeSUT()
        XCTAssertFalse(sut.isContinuing, "Precondition")
        
        sut.schedule {}
        XCTAssertFalse(sut.isContinuing, "Expected not to change state before timer fires")
        
        timer.fire()
        XCTAssertTrue(sut.isContinuing, "Expected state to be true after timer fires")

        sut.invalidate()
        XCTAssertFalse(sut.isContinuing, "Expected state to be false after invalidation")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> (sut: UIActionContinuation, timer: TimerSpy) {
        let timer = TimerSpy()
        let sut = UIActionContinuation(timer: timer)
        return (sut, timer)
    }
    
    private final class TimerSpy: NSObject, UIActionTimer {
        private var action: ((TimerSpy) -> Void)?
        
        var isScheduled: Bool { action != nil }
        
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
