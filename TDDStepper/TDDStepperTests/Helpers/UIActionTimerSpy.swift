//
//  UIActionTimerSpy.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 18.09.2025.
//

@testable import TDDStepper

class UIActionTimerSpy: UIActionTimer {
    private var action: ((UIActionTimer) -> Void)?
    var isScheduled: Bool {
        action != nil
    }
    
    func schedule(action: @escaping (UIActionTimer) -> Void) {
        self.action = action
    }
    
    func invalidate() {
        action = nil
    }
    
    func fire() {
        action?(self)
    }
}
