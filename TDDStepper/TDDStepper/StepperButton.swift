//
//  StepperButton.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 5.09.2025.
//

import UIKit

class StepperButton: UIButton {
    override var intrinsicContentSize: CGSize {
        CGSize(width: 32, height: 32)
    }
    
    typealias TimerCallback = () -> Void
    typealias TimerProvider = (@escaping TimerCallback) -> Timer?
    
    private var timerProvider: TimerProvider?
    private var timer: Timer?
    private var isContinuing = false
    
    convenience init(timerProvider: @escaping TimerProvider) {
        self.init()
        self.timerProvider = timerProvider
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        timer = timerProvider?() { [self] in
            isContinuing = true
            sendActions(for: .touchUpInside)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        timer?.invalidate()
        
        if !isContinuing {
            sendActions(for: .touchUpInside)
        }
    }
}
