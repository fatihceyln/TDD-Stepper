//
//  AcceleratingTimer.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 10.09.2025.
//

import Foundation

class AcceleratingTimer: UIActionTimer {
    struct InitializedWithEmptyTimers: Error {}
    
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
        let startTime = CFAbsoluteTimeGetCurrent()
        timer = timers[timerIndex]
        timer?.schedule(action: { [self] _ in
            action(self)
            
            if CFAbsoluteTimeGetCurrent() - startTime >= accelerationInterval {
                scheduleNextTimer(action: action)
            }
        })
    }
    
    func invalidate() {
        timerIndex = .zero
        timer?.invalidate()
    }
    
    private func scheduleNextTimer(action: @escaping (UIActionTimer) -> Void) {
        timerIndex += 1
        let lastIndex = timers.count
        guard timerIndex < lastIndex else { return }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        timer = timers[timerIndex]
        timer?.schedule(action: { [self] _ in
            action(self)
            
            if CFAbsoluteTimeGetCurrent() - startTime >= accelerationInterval {
                scheduleNextTimer(action: action)
            }
        })
    }
}

extension AcceleratingTimer {
    static func `default`() -> AcceleratingTimer {
        try! AcceleratingTimer(
            accelerationInterval: 2,
            timers: [
                RepeatingUIActionTimer(timeInterval: 0.5),
                RepeatingUIActionTimer(timeInterval: 0.25),
                RepeatingUIActionTimer(timeInterval: 0.1)
            ]
        )
    }
}
