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
    
    func test_sendsEvent_uponTap() {
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
    
    func test_doesNotRequestsTimer_whenNotContinious() {
        let sut = makeSUT(isContinuous: false)
        
        sut.simulateTouchStart()
        XCTAssertNil(timer)
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
    
    func test_doesNotSendEvent_whenTimerFiresAfterTouchEnds() {
        var eventCount = 0
        let sut = makeSUT()
        sut.addAction(UIAction(handler: { _ in eventCount += 1}), for: .touchUpInside)
        sut.simulateTouchStart()
        
        timer?.fire()
        XCTAssertEqual(eventCount, 1)
        
        sut.simulateTouchEnd()
        timer?.fire()
        XCTAssertEqual(eventCount, 1, "Expected not to receive any events after touch ended")
    }
    
    func test_sendsEventWhenTapOccurs_afterTouchEnds() {
        var eventCount = 0
        let sut = makeSUT()
        sut.addAction(UIAction(handler: { _ in eventCount += 1}), for: .touchUpInside)
        sut.simulateTouchStart()
        
        timer?.fire()
        XCTAssertEqual(eventCount, 1)
        
        sut.simulateTouchEnd()
        timer?.fire()
        XCTAssertEqual(eventCount, 1, "Expected not to receive any events after touch ended")
        
        sut.simulateTap()
        XCTAssertEqual(eventCount, 2, "Expected to receive an event when tap occurs")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(isContinuous: Bool = true, file: StaticString = #filePath, line: UInt = #line) -> StepperButton {
        let sut = StepperButton(continuation: UIActionContinuation(timerProvider: { [self] action in
            timer = TimerSpy(block: action)
            return timer!
        }))
        sut.isContinious = isContinuous
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Expected instance to be nil. Potential memory leak.", file: file, line: line)
        }
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
        touchesBegan([], with: nil)
        touchesEnded([], with: nil)
    }
}
