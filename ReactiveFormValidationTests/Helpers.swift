//
//  Helpers.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 18/05/24.
//

import UIKit

func simulateTyping(on textField: UITextField, value: String) {
    textField.sendActions(for: .editingDidBegin)
    textField.text = value
    textField.sendActions(for: .editingChanged)
    textField.sendActions(for: .editingDidEnd)
}
