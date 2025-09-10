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
            updateBackgroundColorByState()
        }
    }
    
    private var continuation: UIActionContinuation?
    private var isContinuing = false
    
    convenience init(continuation: UIActionContinuation) {
        self.init()
        self.continuation = continuation
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        continuation?.schedule(continuation: { [weak self] in
            guard let self else { return }
            isContinuing = true
            sendActions(for: .touchUpInside)
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            continuation?.invalidate()
            isContinuing = false
        }
        
        guard !isContinuing else { return }
        sendActions(for: .touchUpInside)
    }
    
    private func updateBackgroundColorByState() {
        backgroundColor = isEnabled ? .systemGray5 : .systemGray6
    }
}
