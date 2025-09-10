//
//  AcceleratingTimerTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest

class AcceleratingTimer {
    typealias AccelerationInterval = TimeInterval
    typealias TimerProvider = (TimeInterval) -> Timer
    
    private let accelerationInterval: AccelerationInterval
    private let timers: [TimerProvider]
    
    init(accelerationInterval: AccelerationInterval, timers: TimerProvider...) {
        self.accelerationInterval = accelerationInterval
        self.timers = timers
    }
}

class AcceleratingTimerTests: XCTestCase {
    func test_init_doesNotCrash() {
        let _ = AcceleratingTimer(accelerationInterval: .zero)
    }
}
