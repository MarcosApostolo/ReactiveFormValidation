//
//  UsernameTextFieldViewModel.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 19/05/24.
//

import Foundation
import RxSwift

class UsernameTextFieldViewModel {
    var textFieldValue = BehaviorSubject(value: "")
    var textFieldIsTouched = BehaviorSubject(value: false)
    var textFieldIsFocused = BehaviorSubject(value: false)

    var fieldIsValid: Observable<Bool> {
        return Observable
            .combineLatest(textFieldValue, textFieldIsTouched, textFieldIsFocused) { value, isTouched, isFocused in
                return isTouched && value.count <= 32 && !value.isEmpty
            }
    }
    
    var displayErrorLabel: Observable<Bool> {
        return Observable
            .combineLatest(fieldIsValid, textFieldIsFocused) { isValid, isFocused in
                return !isValid && !isFocused
            }
    }
    
    var errorLabel: Observable<String> {
        return textFieldValue.asObservable().map({ value in
            if value.isEmpty {
                return "Username is required!"
            }
            
            if value.count > 32 {
                return "Username too long! Must have less than 32 characters."
            }
            
            return ""
        })
    }

    var textFieldPlaceholder: String {
        "Username"
    }
    
    var usernameTooLongError: String {
        "Username too long! Must have less than 32 characters."
    }
}
