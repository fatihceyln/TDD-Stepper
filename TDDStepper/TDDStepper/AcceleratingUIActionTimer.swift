//
//  AcceleratingUIActionTimer.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 10.09.2025.
//

import Foundation

final class AcceleratingUIActionTimer: UIActionTimer {
    private struct InitializedWithEmptyTimers: Error {}
    typealias AccelerationInterval = TimeInterval
    
    let accelerationInterval: AccelerationInterval
    let timers: [UIActionTimer]
    private(set) var timer: (UIActionTimer)? {
        didSet { oldValue?.invalidate() }
    }
    
    private var timerIndex = 0
    
    init(accelerationInterval: AccelerationInterval, timers: [UIActionTimer]) throws {
        guard !timers.isEmpty else { throw InitializedWithEmptyTimers() }
        self.accelerationInterval = accelerationInterval
        self.timers = timers
    }
    
    func schedule(action: @escaping (UIActionTimer) -> Void) {
        timerIndex = .zero
        timer = timers.first
        timer?.schedule(action: handleTimerAction(action))
    }
    
    func invalidate() {
        timer?.invalidate()
    }
    
    private func handleTimerAction(_ action: @escaping (UIActionTimer) -> Void) -> (UIActionTimer) -> Void {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        return { [weak self] _ in
            guard let self else { return }
            action(self)
            
            if CFAbsoluteTimeGetCurrent() - startTime >= accelerationInterval {
                scheduleNextTimer(action: action)
            }
        }
    }
    
    private func scheduleNextTimer(action: @escaping (UIActionTimer) -> Void) {
        timerIndex += 1
        let lastIndex = timers.count
        guard timerIndex < lastIndex else { return }
        timer = timers[timerIndex]
        timer?.schedule(action: handleTimerAction(action))
    }
}

extension AcceleratingUIActionTimer {
    static func `default`() -> AcceleratingUIActionTimer {
        try! AcceleratingUIActionTimer(
            accelerationInterval: 2,
            timers: [
                RepeatingUIActionTimer(timeInterval: 0.5),
                RepeatingUIActionTimer(timeInterval: 0.25),
                RepeatingUIActionTimer(timeInterval: 0.1)
            ]
        )
    }
}
