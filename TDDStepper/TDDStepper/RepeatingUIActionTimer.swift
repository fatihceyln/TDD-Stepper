//
//  RepeatingUIActionTimer.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 10.09.2025.
//

import Foundation

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
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}
