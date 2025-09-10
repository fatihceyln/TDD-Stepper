//
//  AcceleratingTimerTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest

class AcceleratingTimer {
    typealias TimerProvider = (TimeInterval) -> Timer
    private let timers: [TimerProvider]
    
    init(timers: TimerProvider...) {
        self.timers = timers
    }
}

class AcceleratingTimerTests: XCTestCase {
    func test_init_doesNotCrash() {
        let _ = AcceleratingTimer()
    }
}
