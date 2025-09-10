//
//  UIActionContinuationTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest

class UIActionContinuation {
    typealias TimerProvider = (@escaping () -> Void) -> Timer
    private let timerProvider: TimerProvider
    
    init(timerProvider: @escaping TimerProvider) {
        self.timerProvider = timerProvider
    }
    
    func schedule(continuation handler: @escaping () -> Void) {
        timerProvider({ handler() })
    }
}


class UIActionContinuationTests: XCTestCase {
    func test_init_doesNotRequestsTimerUponCreation() {
        var timer: TimerSpy?
        let _ = UIActionContinuation(timerProvider: { action in
            timer = TimerSpy(callback: action)
            return timer!
        })
        
        XCTAssertNil(timer, "Expected not to be requested a timer upon creation")
    }
    
    func test_schedule_requestsTimer() {
        var timer: TimerSpy?
        let sut = UIActionContinuation(timerProvider: { action in
            timer = TimerSpy(callback: action)
            return timer!
        })
        
        sut.schedule {}
        
        XCTAssertNotNil(timer, "Expected timer to be requested after schedule command")
    }
    
    func test_schedule_notifiesHandlerWhenTimerFires() {
        var eventCount = 0
        var timer: TimerSpy?
        let sut = UIActionContinuation(timerProvider: { action in
            timer = TimerSpy(callback: action)
            return timer!
        })
        
        sut.schedule { eventCount += 1 }
        timer?.fire()
        XCTAssertEqual(eventCount, 1, "Expected to receive an event when timer fires")
        
        timer?.fire()
        XCTAssertEqual(eventCount, 2, "Expected to receive another event when timer fires again")
    }
    
    // MARK: - Helpers
    private final class TimerSpy: Timer {
        private var callback: (() -> Void)?
        
        convenience init(callback: @escaping () -> Void) {
            self.init()
            self.callback = callback
        }
        
        override func fire() {
            callback?()
        }
        
        override func invalidate() {
            callback = nil
        }
    }
}
