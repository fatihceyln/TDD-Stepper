//
//  AcceleratingTimerTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest

class AcceleratingTimer {
    typealias Rate = TimeInterval
    typealias Rates = [TimeInterval]
    typealias TimerProvider = (Rate) -> Timer
    
    private let rates: Rates
    private let timerProvider: TimerProvider
    
    private(set) var rate: Rate?
    private(set) var timer: Timer?
    
    init(rates: Rates, timerProvider: @escaping TimerProvider) {
        self.rates = rates
        self.timerProvider = timerProvider
    }
    
    func schedule() {
        rate = rates.first
        guard let rate else { return }
        timer = timerProvider(rate)
    }
}

class AcceleratingTimerTests: XCTestCase {
    func test_initWithEmptyRates_doesNotSelectAnyRate() {
        let sut = AcceleratingTimer(rates: [], timerProvider: { _ in TimerSpy() })
        
        XCTAssertNil(sut.rate)
    }
    
    func test_schedule_selectesFirstRate() {
        let firstRate = 0.1
        let secondRate = 0.2
        let sut = AcceleratingTimer(rates: [firstRate, secondRate], timerProvider: { _ in TimerSpy() })
        
        sut.schedule()
        
        XCTAssertEqual(sut.rate, firstRate)
    }
    
    func test_schedule_requestsTimerWithSelectedRate() {
        let rate = 0.3
        let sut = AcceleratingTimer(rates: [rate], timerProvider: { rate in
            TimerSpy(timeInterval: rate)
        })
        
        sut.schedule()
        
        XCTAssertEqual(sut.rate, sut.timer?.timeInterval)
    }
    
    // MARK: - Helpers
    private final class TimerSpy: Timer {
        private var _timeInterval: TimeInterval = .zero
        override var timeInterval: TimeInterval { _timeInterval }
        
        convenience init(timeInterval: TimeInterval) {
            self.init()
            self._timeInterval = timeInterval
        }
    }
}
