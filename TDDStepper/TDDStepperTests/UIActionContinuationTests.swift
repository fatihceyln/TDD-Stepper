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
}


class UIActionContinuationTests: XCTestCase {
    func test_init_doesNotRequestsTimerUponCreation() {
        var timer: TimerSpy?
        let sut = UIActionContinuation(timerProvider: { action in
            timer = TimerSpy(callback: action)
            return timer!
        })
        
        XCTAssertNil(timer, "Expected not to be requested a timer upon creation")
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
