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
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .systemGray5 : .systemGray6
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            let scale = isHighlighted ? 1.1 : 1.0
            transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    private lazy var continuation = UIActionContinuation(timerProvider: { action in
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            action()
        })
    })
    
    var isContinuous = true
    
    convenience init(continuation: UIActionContinuation) {
        self.init()
        self.continuation = continuation
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        
        guard isContinuous else { return }
        continuation.schedule(continuation: { [weak self] in
            guard let self else { return }
            sendActions(for: .touchUpInside)
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            continuation.invalidate()
            isHighlighted = false
        }
        
        guard continuation.isContinuing == false else { return }
        sendActions(for: .touchUpInside)
    }
}
