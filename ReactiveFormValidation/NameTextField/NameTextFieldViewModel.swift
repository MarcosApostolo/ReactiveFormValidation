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
            .combineLatest(textFieldValue, textFieldIsTouched, textFieldIsFocused) { value, isTouched, isFocused in
                return isTouched && !value.isEmpty
            }
    }
    
    var displayErrorLabel: Observable<Bool> {
        return Observable
            .combineLatest(fieldIsValid, textFieldIsFocused) { isValid, isFocused in
                return !isValid && !isFocused
            }
    }
}
