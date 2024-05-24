//
//  EmailTextFieldViewModel.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 18/05/24.
//

import Foundation
import RxSwift

class EmailTextFieldViewModel {
    var textFieldValue = BehaviorSubject(value: "")
    var textFieldIsTouched = BehaviorSubject(value: false)
    var textFieldIsFocused = BehaviorSubject(value: false)

    var fieldIsValid: Observable<Bool> {
        return Observable
            .combineLatest(textFieldValue, textFieldIsTouched) { value, isTouched in
                return isTouched && isValidEmail(email: value) && !value.isEmpty
            }
            .distinctUntilChanged()
    }
    
    var displayErrorLabel: Observable<Bool> {
        return Observable
            .combineLatest(fieldIsValid, textFieldIsFocused) { isValid, isFocused in
                return !isValid && !isFocused
            }
            .distinctUntilChanged()
    }
    
    var errorLabel: Observable<String> {
        return textFieldValue.asObservable().map({ value in
            if value.isEmpty {
                return "Email is required!"
            }
            
            if !isValidEmail(email: value) {
                return "Please type an valid email"
            }
            
            return ""
        })
        .distinctUntilChanged()
    }
    
    var emailTextFieldPlaceholder: String {
        "Email"
    }
}

