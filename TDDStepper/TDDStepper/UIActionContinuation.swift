//
//  UIActionContinuation.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 10.09.2025.
//

import Foundation

class UIActionContinuation {
    typealias TimerProvider = (@escaping () -> Void) -> Timer
    private let timerProvider: TimerProvider
    private var timer: Timer?
    
    init(timerProvider: @escaping TimerProvider) {
        self.timerProvider = timerProvider
    }
    
    func schedule(continuation handler: @escaping () -> Void) {
        timer = timerProvider({ handler() })
    }
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}
