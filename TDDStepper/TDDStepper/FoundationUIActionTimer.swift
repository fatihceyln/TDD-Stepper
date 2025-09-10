//
//  FoundationUIActionTimer.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 10.09.2025.
//

import Foundation

struct TimerSpecs {
    let timeInterval: TimeInterval
    let repeats: Bool
    
    static func `default`() -> TimerSpecs {
        TimerSpecs(timeInterval: 1, repeats: true)
    }
}

class FoundationUIActionTimer: UIActionTimer {
    typealias TimerProvider = (TimerSpecs) -> Timer
    private let timerSpecs: TimerSpecs
    private let timerProvider: TimerProvider
    
    private(set) var timer: Timer?
    
    init(timerSpecs: TimerSpecs = .default(), timerProvider: @escaping TimerProvider) {
        self.timerSpecs = timerSpecs
        self.timerProvider = timerProvider
    }
    
    func schedule(action: @escaping (any UIActionTimer) -> Void) {
        timer = timerProvider(timerSpecs)
    }
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}
