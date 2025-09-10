//
//  UIActionContinuation.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 10.09.2025.
//

import Foundation

class UIActionContinuation {
    private let timer: UIActionTimer
    private(set) var isContinuing = false
    
    init(timer: UIActionTimer) {
        self.timer = timer
    }
    
    func schedule(continuation handler: @escaping () -> Void) {
        timer.schedule(action: { [self] _ in
            isContinuing = true
            handler()
        })
    }
    
    func invalidate() {
        isContinuing = false
        timer.invalidate()
    }
}
