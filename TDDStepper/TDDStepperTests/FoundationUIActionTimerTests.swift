//
//  FoundationUIActionTimerTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 10.09.2025.
//

import XCTest
@testable import TDDStepper

final class FoundationUIActionTimer: UIActionTimer {
    private(set) var timer: Timer?
    
    func schedule(action: @escaping (any UIActionTimer) -> Void) {}
    
    func invalidate() {}
}

class FoundationUIActionTimerTests: XCTestCase {
    func test_init_doesNotSchduleTimer() {
        let sut = FoundationUIActionTimer()
        XCTAssertNil(sut.timer)
    }
}
