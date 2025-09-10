//
//  Stepper.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 5.09.2025.
//

import UIKit

public class Stepper: UIControl {
    public var value: UInt = 0 {
        didSet {
            if value > maximumValue {
                value = maximumValue
            }
            
            if value < minimumValue {
                value = minimumValue
            }
            
            textLabel.text = String(value)
            updateButtons()
            sendActions(for: .valueChanged)
        }
    }
    
    public var minimumValue: UInt = 0 {
        didSet {
            if minimumValue > value {
                value = minimumValue
            }
            
            if minimumValue > maximumValue {
                maximumValue = minimumValue
            }
        }
    }
    
    public var maximumValue: UInt = 10 {
        didSet {
            if maximumValue < minimumValue {
                minimumValue = maximumValue
            }
        }
    }
    
    public var stepValue: UInt = 1
    
    private(set) lazy var decrementButton = makeButton(title: "-", actionHandler: handleDecrementButtonTap())
    private(set) lazy var incrementButton = makeButton(title: "+", actionHandler: handleIncrementButtonTap())
    private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    public convenience init() {
        self.init(frame: .zero)
        
        clipsToBounds = true
        backgroundColor = .systemBackground
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerRadius = 25
        
        textLabel.text = String(value)
        updateButtons()
        setupConstraints()
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let fittingSize = systemLayoutSizeFitting(CGSize(width: -1, height: 50), withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
        return fittingSize
    }
    
    private func updateButtons() {
        decrementButton.isEnabled = value > minimumValue
        incrementButton.isEnabled = value < maximumValue
    }
    
    private func handleIncrementButtonTap() -> () -> Void {
        { [unowned self] in
            value += stepValue
        }
    }
    
    private func handleDecrementButtonTap() -> () -> Void {
        { [unowned self] in
            let nextValue: Int = Int(value) - Int(stepValue)
            
            if nextValue < 0 {
                value = .zero
            } else {
                value = UInt(nextValue)
            }
        }
    }
}

extension Stepper {
    private func setupConstraints() {
        addSubview(decrementButton)
        addSubview(textLabel)
        addSubview(incrementButton)
        
        [decrementButton, textLabel, incrementButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            decrementButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            decrementButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            decrementButton.widthAnchor.constraint(equalToConstant: 32),
            decrementButton.heightAnchor.constraint(equalToConstant: 32),
            
            textLabel.leadingAnchor.constraint(equalTo: decrementButton.trailingAnchor, constant: 4),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: incrementButton.leadingAnchor, constant: -4),
            
            incrementButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            incrementButton.widthAnchor.constraint(equalToConstant: 32),
            incrementButton.heightAnchor.constraint(equalToConstant: 32),
            incrementButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func makeButton(title: String, actionHandler: @escaping () -> Void) -> UIButton {
        let button = StepperButton(frame: .zero)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.label, .font: UIFont.preferredFont(forTextStyle: .subheadline)]), for: .normal)
        button.addAction(UIAction(handler: { _ in actionHandler() }), for: .touchUpInside)
        return button
    }
}
