//
//  PasswordValidatorPolicy.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 21/05/24.
//

import Foundation

class PasswordValidatorPolicy {
    static let minLength = 8
    static let maxLength = 16
    
    private init() {}
    
    static func isPasswordMinLengthValid(_ password: String) -> Bool {
        return password.count >= PasswordValidatorPolicy.minLength
    }
    
    static func isPasswordMaxLengthValid(_ password: String) -> Bool {
        return password.count <= PasswordValidatorPolicy.maxLength
    }
}
