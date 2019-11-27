//
//  ButtonValidationHelper.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 27.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

final class ButtonValidationHelper {
    
    var textFields: [UITextField]
    var button: UIButton
    
    init(textFields: [UITextField], button: UIButton) {
        self.textFields = textFields
        self.button = button
        
        attachTargetsToTextFields()
        button.isEnabled = false
        checkForEmptyFields()
    }
    
    private func attachTargetsToTextFields() {
        for textfield in textFields {
            textfield.addTarget(self,
                                action: #selector(textFieldsIsNotEmpty),
                                for: .editingChanged)
        }
    }
    
    @objc private func textFieldsIsNotEmpty(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        checkForEmptyFields()
    }
    
    
    private func checkForEmptyFields() {
        for textField in textFields{
            guard let textFieldVar = textField.text, !textFieldVar.isEmpty else {
                button.isEnabled = false
                return
            }
        }
        
        button.isEnabled = true
    }
}
