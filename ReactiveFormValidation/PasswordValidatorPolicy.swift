//
//  PasswordValidatorPolicy.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 21/05/24.
//

import Foundation

class PasswordValidatorPolicy {
    static let minLength = 8
    
    static func isPasswordLengthValid(_ password: String) -> Bool {
        return password.count >= PasswordValidatorPolicy.minLength
    }
}
