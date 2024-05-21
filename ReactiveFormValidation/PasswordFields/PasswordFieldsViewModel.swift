//
//  PasswordFieldsViewModel.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 21/05/24.
//

import Foundation
import RxSwift

class PasswordFieldsViewModel {
    var newPasswordValue = BehaviorSubject(value: "")
    var newPasswordValueIsTouched = BehaviorSubject(value: false)
    var newPasswordValueIsFocused = BehaviorSubject(value: false)
    
    var confirmPasswordValue = BehaviorSubject(value: "")

    var passwordsAreValid: Observable<Bool> {
        return Observable
            .combineLatest(
                newPasswordValue,
                newPasswordValueIsTouched,
                confirmPasswordValue
            ) { newValue, isTouched, confirmValue in
                return isTouched
                    && PasswordValidatorPolicy.isPasswordMinLengthValid(newValue)
                    && PasswordValidatorPolicy.isPasswordMaxLengthValid(newValue)
                    && newValue == confirmValue
            }
            .distinctUntilChanged()
            .share()
    }
    
    var displayErrorLabel: Observable<Bool> {
        return Observable
            .combineLatest(passwordsAreValid, newPasswordValueIsFocused) { isValid, isFocused in
                return !isValid && !isFocused
            }
    }
    
    var errorLabel: Observable<String> {
        return Observable.combineLatest(newPasswordValue, confirmPasswordValue) { newValue, confirmValue in
            if !PasswordValidatorPolicy.isPasswordMinLengthValid(newValue) {
                return "Password length must be at least \(PasswordValidatorPolicy.minLength) characters"
            }
            
            if !PasswordValidatorPolicy.isPasswordMaxLengthValid(newValue) {
                return "Password length must be no longer than \(PasswordValidatorPolicy.maxLength) characters"
            }
            
            if newValue != confirmValue {
                return "Passwords don't match."
            }

            return ""
        }
    }

    var nameTextFieldPlaceholder: String {
        "New Password"
    }
}
