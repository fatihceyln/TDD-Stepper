//
//  ExampleViewController.swift
//  TDDStepperApp
//
//  Created by Fatih Kilit on 10.09.2025.
//

import UIKit
import TDDStepper

final class ExampleViewController: UIViewController {
    @IBOutlet private var stepper: Stepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepper.maximumValue = 20_000
        stepper.value = 10
    }
}

