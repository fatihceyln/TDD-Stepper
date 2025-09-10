//
//  RepeatingUIActionTimerTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest
@testable import TDDStepper

class RepeatingUIActionTimerTests: XCTestCase {
    func test_init_doesNotSchduleTimer() {
        let sut = makeSUT()
        XCTAssertNil(sut.timer)
    }
    
    func test_initWithDefaultTimeInterval() {
        let sut = makeSUT()
        XCTAssertEqual(sut.timeInterval, 0.5)
    }
    
    func test_schedule_schedulesTimerWithTimeInterval() throws {
        let sut = makeSUT(timeInterval: 1.12)
        
        sut.schedule(action: { _ in })
        
        let timer = try XCTUnwrap(sut.timer)
        XCTAssertEqual(timer.timeInterval, 1.12)
        XCTAssertTrue(timer.isValid)
    }
    
    func test_invalidateAfterSchedule_invalidatesTimer() throws {
        let sut = makeSUT()
        
        sut.schedule(action: { _ in })
        let timer = try XCTUnwrap(sut.timer)
        
        sut.invalidate()
        XCTAssertFalse(timer.isValid)
    }
    
    func test_invalidate_removesReferenceToTimer() {
        let sut = makeSUT()
        
        sut.schedule(action: { _ in })
        sut.invalidate()
        
        XCTAssertNil(sut.timer)
    }
    
    private func makeSUT(timeInterval: TimeInterval? = nil) -> RepeatingUIActionTimer {
        let sut = timeInterval.map { RepeatingUIActionTimer(timeInterval: $0) } ?? RepeatingUIActionTimer()
        trackForMemoryLeaks(sut)
        return sut
    }
}
