//
//  RepeatingUIActionTimerTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest
@testable import TDDStepper

final class RepeatingUIActionTimer: UIActionTimer {
    private(set) var timer: Timer?
    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval = 0.5) {
        self.timeInterval = timeInterval
    }
    
    func schedule(action: @escaping (any UIActionTimer) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [self] _ in
            action(self)
        })
    }
    
    func invalidate() {}
}

class RepeatingUIActionTimerTests: XCTestCase {
    func test_init_doesNotSchduleTimer() {
        let sut = RepeatingUIActionTimer()
        XCTAssertNil(sut.timer)
    }
    
    func test_initWithDefaultTimeInterval() {
        let sut = RepeatingUIActionTimer()
        XCTAssertEqual(sut.timeInterval, 0.5)
    }
    
    func test_schedule_schedulesTimerWithTimeInterval() {
        let sut = RepeatingUIActionTimer(timeInterval: 1.12)
        
        sut.schedule(action: { _ in })
        
        XCTAssertEqual(sut.timer?.timeInterval, 1.12)
    }
}
