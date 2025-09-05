//
//  StepperTests.swift
//  TDDStepperTests
//
//  Created by Fatih Kilit on 4.09.2025.
//

import XCTest
@testable import TDDStepper

class StepperTests: XCTestCase {
    // MARK: - Behavior tests
    func test_defaultValues() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.value, 0, "Default value")
        XCTAssertEqual(sut.minimumValue, 0, "Default minimum value")
        XCTAssertEqual(sut.maximumValue, 10, "Default maximum value")
        XCTAssertEqual(sut.stepValue, 1, "Default step value")
    }
    
    func test_setMinimumValueBeyondValue_matchesValueWithMinimumValue() {
        let sut = makeSUT()
        sut.value = 1
        
        sut.minimumValue = 5
        
        XCTAssertEqual(sut.value, 5, "Expected value to be equal with minimum value")
    }
    
    func test_setMinimumValueBeyonMaximumValue_matchesMaximumValueWithMinimum() {
        let sut = makeSUT()
        sut.maximumValue = 1
        
        sut.minimumValue = 20
        
        XCTAssertEqual(sut.maximumValue, 20, "Expected maximum value to be equal with minimum value")
    }
    
    func test_setMaximumValueBelowMinimumValue_matchesMinimumValueWithMaximum() {
        let sut = makeSUT()
        sut.minimumValue = 5
        
        sut.maximumValue = 1
        
        XCTAssertEqual(sut.minimumValue, 1, "Expected minimum value to be equal with maximum value")
    }
    
    func test_setValueBeyondMaximum_limitsValueToMaximum() {
        let sut = makeSUT()
        sut.maximumValue = 5
        
        sut.value = 10
        
        XCTAssertEqual(sut.value, 5, "Expected value to be limited by maximum value")
    }
    
    func test_setValueBelowMinimum_limitsValueToMinimum() {
        let sut = makeSUT()
        sut.minimumValue = 3
        
        sut.value = 1
        
        XCTAssertEqual(sut.value, 3, "Expected value to be limited by minimum value")
    }
    
    func test_sendsValueChangedEvent_whenValueChanges() {
        var eventCount = 0
        let sut = makeSUT()
        sut.addAction(UIAction(handler: { _ in eventCount += 1 }), for: .valueChanged)
        
        sut.value = 1
        XCTAssertEqual(eventCount, 1)
        
        sut.simulateTapOnIncrementButton()
        XCTAssertEqual(eventCount, 2)
        
        sut.simulateTapOnDecrementButton()
        XCTAssertEqual(eventCount, 3)
    }
    
    // MARK: - Button Tests
    
    func test_incrementButtonTap_increasesValue() {
        let sut = makeSUT()
        sut.maximumValue = 10
        sut.value = 0
        
        sut.simulateTapOnIncrementButton()
        
        XCTAssertEqual(sut.value, 1, "Expected value to be increased")
    }
    
    func test_incrementButtonTap_increasesValueByStepValue() {
        let sut = makeSUT()
        sut.maximumValue = 10
        sut.value = 0
        sut.stepValue = 5
        
        sut.simulateTapOnIncrementButton()
        
        XCTAssertEqual(sut.value, 5, "Expected value to be increased by step value")
    }
    
    func test_decrementButtonTap_decrementsValue() {
        let sut = makeSUT()
        sut.maximumValue = 10
        sut.value = 3
        
        sut.simulateTapOnDecrementButton()
        
        XCTAssertEqual(sut.value, 2, "Expected value to be decreased")
    }
    
    func test_decrementButtonTap_decrementsValueByStepValue() {
        let sut = makeSUT()
        sut.maximumValue = 10
        sut.value = 10
        sut.stepValue = 5
        
        sut.simulateTapOnDecrementButton()
        
        XCTAssertEqual(sut.value, 5, "Expected value to be decreased by step value")
    }
    
    func test_decrementButtonTap_doesNotDecrementsValueToNegative() {
        let sut = makeSUT()
        sut.minimumValue = 0
        sut.value = 0
        
        sut.simulateTapOnDecrementButton()
        XCTAssertEqual(sut.value, 0, "Expected not to change value")
        
        sut.value = 2
        sut.stepValue = 3
        sut.simulateTapOnDecrementButton()
        XCTAssertEqual(sut.value, 0, "Expected value to be zero")
    }
    
    // MARK: - Label Tests
    func test_textLabel_rendersValue() {
        let sut = makeSUT()
        XCTAssertEqual(sut.textLabel.text, String(sut.value), "Default value")
        
        sut.value = 1
        XCTAssertEqual(sut.textLabel.text, "1")
        
        sut.simulateTapOnIncrementButton()
        XCTAssertEqual(sut.textLabel.text, "2")
        
        sut.simulateTapOnDecrementButton()
        XCTAssertEqual(sut.textLabel.text, "1")
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> Stepper {
        let sut = Stepper()
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Expected sut to be nil. Potential memory leak.", file: file, line: line)
        }
        return sut
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
