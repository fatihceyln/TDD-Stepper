//
//  Stepper.swift
//  TDDStepper
//
//  Created by Fatih Kilit on 5.09.2025.
//

import UIKit

public class Stepper: UIControl {
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }
    
    private var stepperState = StepperState()
    
    public var value: UInt {
        get { stepperState.value }
        set {
            stepperState.value = newValue
            textLabel.text = String(value)
            updateButtons()
            sendActions(for: .valueChanged)
        }
    }
    
    public var minimumValue: UInt {
        get { stepperState.minimumValue }
        set { stepperState.minimumValue = newValue }
    }
    
    public var maximumValue: UInt {
        get { stepperState.maximumValue }
        set { stepperState.maximumValue = newValue }
    }
    
    public var stepValue: UInt {
        get { stepperState.stepValue }
        set { stepperState.stepValue = newValue }
    }
    
    private(set) lazy var decrementButton = makeButton(title: "-", actionHandler: handleDecrementButtonTap())
    private(set) lazy var incrementButton = makeButton(title: "+", actionHandler: handleIncrementButtonTap())
    private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
        backgroundColor = .systemBackground
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerRadius = 25
        
        textLabel.text = String(value)
        updateButtons()
        StepperLayout.configure(self)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let fittingSize = systemLayoutSizeFitting(intrinsicContentSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
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
    private func makeButton(title: String, actionHandler: @escaping () -> Void) -> UIButton {
        let button = StepperButton(frame: .zero)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.label, .font: UIFont.preferredFont(forTextStyle: .subheadline)]), for: .normal)
        button.addAction(UIAction(handler: { _ in actionHandler() }), for: .touchUpInside)
        return button
    }
}
