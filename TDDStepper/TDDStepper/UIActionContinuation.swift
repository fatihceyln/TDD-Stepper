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
    
    private(set) var isContinuing = false
    
    init(timerProvider: @escaping TimerProvider) {
        self.timerProvider = timerProvider
    }
    
    func schedule(continuation handler: @escaping () -> Void) {
        timer = timerProvider({ [self] in
            isContinuing = true
            handler()
        })
    }
    
    func invalidate() {
        isContinuing = false
        
        timer?.invalidate()
        timer = nil
    }
}
