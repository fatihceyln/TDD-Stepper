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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
}
