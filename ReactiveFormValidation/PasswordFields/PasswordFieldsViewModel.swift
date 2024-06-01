//
//  PasswordFieldsViewModel.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 21/05/24.
//

import Foundation
import RxSwift

enum PasswordFormFieldValidationState {
    case error
    case valid
    case initial
}

class PasswordFieldsViewModel {
    private let disposeBag = DisposeBag()
    
    var newPasswordValue = BehaviorSubject(value: "")
    var newPasswordValueIsTouched = BehaviorSubject(value: false)
    var confirmPasswordValueIsTouched = BehaviorSubject(value: false)
    var newPasswordValueIsFocused = BehaviorSubject(value: false)
    
    var confirmPasswordValue = BehaviorSubject(value: "")
    
    var newPasswordVisibility = BehaviorSubject(value: true)
    var confirmPasswordVisibility = BehaviorSubject(value: true)

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
            .skip(1)
            .distinctUntilChanged()
    }
    
    var errorMessage: Observable<String> {
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
        .distinctUntilChanged()
    }
    
    var displayNewPasswordState: Observable<PasswordFormFieldValidationState> {
        return Observable
            .combineLatest(
                newPasswordValue,
                newPasswordValueIsTouched,
                newPasswordValueIsFocused
            ) { newValue, isTouched, isFocused in
                if !isTouched {
                    return .initial
                }
                
                if isFocused {
                    return .valid
                }
                
                return PasswordValidatorPolicy.isPasswordMinLengthValid(newValue)
                    && PasswordValidatorPolicy.isPasswordMaxLengthValid(newValue) ? .valid : .error
            }
            .distinctUntilChanged()
            .share()
    }
    
    var displayStateOnPasswords: Observable<PasswordFormFieldValidationState> {
        return Observable
            .combineLatest(newPasswordValue, confirmPasswordValue, confirmPasswordValueIsTouched) { newValue, confirmValue, confirmIsTouched in
                if !confirmIsTouched {
                    return .initial
                }
                
                return newValue == confirmValue ? .valid : .error
            }
    }

    var newPasswordPlaceholder: String {
        "New Password"
    }
    
    var confirmPasswordPlaceholder: String {
        "Confirm Password"
    }
}
