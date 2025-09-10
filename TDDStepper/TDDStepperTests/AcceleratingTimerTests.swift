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
    
    private let rates: Rates
    private(set) var rate: Rate?
    
    init(rates: Rates) {
        self.rates = rates
    }
    
    func schedule() {
        rate = rates.first
    }
}

class AcceleratingTimerTests: XCTestCase {
    func test_initWithEmptyRates_doesNotSelectAnyRate() {
        let sut = AcceleratingTimer(rates: [])
        
        XCTAssertNil(sut.rate)
    }
    
    func test_schedule_selectesFirstRate() {
        let firstRate = 0.1
        let secondRate = 0.2
        let sut = AcceleratingTimer(rates: [firstRate, secondRate])
        
        sut.schedule()
        
        XCTAssertEqual(sut.rate, firstRate)
    }
}
