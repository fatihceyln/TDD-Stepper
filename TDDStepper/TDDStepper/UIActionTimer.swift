//
//  UIActionTimer.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 10.09.2025.
//

import Foundation

protocol UIActionTimer {
    func schedule(action: @escaping (UIActionTimer) -> Void)
    func invalidate()
}
