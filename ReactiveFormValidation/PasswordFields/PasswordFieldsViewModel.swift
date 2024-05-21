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

    var newPasswordFieldIsValid: Observable<Bool> {
        return Observable
            .combineLatest(newPasswordValue, newPasswordValueIsTouched, newPasswordValueIsFocused) { value, isTouched, isFocused in
                return isTouched && value.count >= 8
            }.share()
    }
    
    var displayErrorLabel: Observable<Bool> {
        return Observable
            .combineLatest(newPasswordFieldIsValid, newPasswordValueIsFocused) { isValid, isFocused in
                return !isValid && !isFocused
            }
    }
    
    var errorLabel: Observable<String> {
        return newPasswordValue
            .asObservable()
            .map { value in
                if value.count < 8 {
                    return "Password length must be at least 8 characters"
                }
                
                return ""
        }
    }

    var nameTextFieldPlaceholder: String {
        "New Password"
    }
}
