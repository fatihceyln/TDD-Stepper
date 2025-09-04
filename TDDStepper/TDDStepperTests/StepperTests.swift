//
//  StepperTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 4.09.2025.
//

import XCTest

class Stepper {
    var value: UInt = 0 {
        didSet {
            if value > maximumValue {
                value = maximumValue
            }
            
            if value < minimumValue {
                value = minimumValue
            }
        }
    }
    
    var minimumValue: UInt = 0 {
        didSet {
            if minimumValue > value {
                value = minimumValue
            }
            
            if minimumValue > maximumValue {
                maximumValue = minimumValue
            }
        }
    }
    
    var maximumValue: UInt = 10 {
        didSet {
            if maximumValue < minimumValue {
                minimumValue = maximumValue
            }
        }
    }
    
    var stepValue: UInt = 1
    
    private(set) lazy var incrementButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addAction(UIAction(handler: { [unowned self] _ in value += stepValue }), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var decrementButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addAction(UIAction(handler: { [unowned self] _ in value -= 1 }), for: .touchUpInside)
        return button
    }()
}

class StepperTests: XCTestCase {
    // MARK: - Behavior tests
    func test_defaultValues() {
        let sut = Stepper()
        
        XCTAssertEqual(sut.value, 0, "Default value")
        XCTAssertEqual(sut.minimumValue, 0, "Default minimum value")
        XCTAssertEqual(sut.maximumValue, 10, "Default maximum value")
        XCTAssertEqual(sut.stepValue, 1, "Default step value")
    }
    
    func test_setMinimumValueBeyondValue_matchesValueWithMinimumValue() {
        let sut = Stepper()
        sut.value = 1
        
        sut.minimumValue = 5
        
        XCTAssertEqual(sut.value, 5, "Expected value to be equal with minimum value")
    }
    
    func test_setMinimumValueBeyonMaximumValue_matchesMaximumValueWithMinimum() {
        let sut = Stepper()
        sut.maximumValue = 1
        
        sut.minimumValue = 20
        
        XCTAssertEqual(sut.maximumValue, 20, "Expected maximum value to be equal with minimum value")
    }
    
    func test_setMaximumValueBelowMinimumValue_matchesMinimumValueWithMaximum() {
        let sut = Stepper()
        sut.minimumValue = 5
        
        sut.maximumValue = 1
        
        XCTAssertEqual(sut.minimumValue, 1, "Expected minimum value to be equal with maximum value")
    }
    
    func test_setValueBeyondMaximum_limitsValueToMaximum() {
        let sut = Stepper()
        sut.maximumValue = 5
        
        sut.value = 10
        
        XCTAssertEqual(sut.value, 5, "Expected value to be limited by maximum value")
    }
    
    func test_setValueBelowMinimum_limitsValueToMinimum() {
        let sut = Stepper()
        sut.minimumValue = 3
        
        sut.value = 1
        
        XCTAssertEqual(sut.value, 3, "Expected value to be limited by minimum value")
    }
    
    // MARK: - Button Tests
    
    func test_incrementButtonTap_increasesValue() {
        let sut = Stepper()
        sut.maximumValue = 10
        sut.value = 0
        
        sut.simulateTapOnIncrementButton()
        
        XCTAssertEqual(sut.value, 1, "Expected value to be increased")
    }
    
    func test_incrementButtonTap_increasesValueByStepValue() {
        let sut = Stepper()
        sut.maximumValue = 10
        sut.value = 0
        sut.stepValue = 5
        
        sut.simulateTapOnIncrementButton()
        
        XCTAssertEqual(sut.value, 5, "Expected value to be increased by step value")
    }
    
    func test_decrementButtonTap_decrementsValue() {
        let sut = Stepper()
        sut.maximumValue = 10
        sut.value = 3
        
        sut.simulateTapOnDecrementButton()
        
        XCTAssertEqual(sut.value, 2, "Expected value to be decreased")
    }
}

private extension Stepper {
    func simulateTapOnIncrementButton() {
        incrementButton.sendActions(for: .touchUpInside)
    }
    
    func simulateTapOnDecrementButton() {
        decrementButton.sendActions(for: .touchUpInside)
    }
}
