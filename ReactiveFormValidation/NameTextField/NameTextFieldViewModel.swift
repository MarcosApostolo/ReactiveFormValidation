//
//  NameTextFieldViewModel.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 18/05/24.
//

import Foundation
import RxSwift

class NameTextFieldViewModel {
    var textFieldValue = BehaviorSubject(value: "")
    var textFieldIsTouched = BehaviorSubject(value: false)
    var textFieldIsFocused = BehaviorSubject(value: false)

    var fieldIsValid: Observable<Bool> {
        return Observable
            .combineLatest(textFieldValue, textFieldIsTouched) { value, isTouched in
                return isTouched && !value.isEmpty
            }
            .distinctUntilChanged()
            
            .share()
    }
    
    var displayErrorLabel: Observable<Bool> {
        return Observable
            .combineLatest(fieldIsValid, textFieldIsFocused) { isValid, isFocused in
                return !isValid && !isFocused
            }
            .distinctUntilChanged()
   }

    var nameTextFieldPlaceholder: String {
        "Name"
    }
    
    var nameErrorRequiredError: String {
        "Name is required!"
    }
}
