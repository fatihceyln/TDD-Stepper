//
//  StepperLayout.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 10.09.2025.
//

import UIKit

struct StepperLayout {
    private init() {}
    
    static func configure(_ stepper: Stepper) {
        let decrementButton = stepper.decrementButton
        let textLabel = stepper.textLabel
        let incrementButton = stepper.incrementButton
        
        stepper.addSubview(decrementButton)
        stepper.addSubview(textLabel)
        stepper.addSubview(incrementButton)
        
        [decrementButton, textLabel, incrementButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            decrementButton.leadingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: 8),
            decrementButton.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            decrementButton.widthAnchor.constraint(equalToConstant: 32),
            decrementButton.heightAnchor.constraint(equalToConstant: 32),
            
            textLabel.leadingAnchor.constraint(equalTo: decrementButton.trailingAnchor, constant: 4),
            textLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: incrementButton.leadingAnchor, constant: -4),
            
            incrementButton.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            incrementButton.widthAnchor.constraint(equalToConstant: 32),
            incrementButton.heightAnchor.constraint(equalToConstant: 32),
            incrementButton.trailingAnchor.constraint(equalTo: stepper.trailingAnchor, constant: -8)
        ])
    }
}
