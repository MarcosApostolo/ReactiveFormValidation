//
//  NameTextFieldViewModel.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import Foundation
import RxSwift

class NameTextFieldViewModel {
    var nameTextFieldValue = BehaviorSubject(value: "")
    var nameTextFieldIsTouched = BehaviorSubject(value: false)
    var nameTextFieldIsFocused = BehaviorSubject(value: false)

    var nameFieldIsValid: Observable<Bool> {
        return Observable
            .combineLatest(nameTextFieldValue, nameTextFieldIsTouched, nameTextFieldIsFocused) { value, isTouched, isFocused in
                return isTouched && !value.isEmpty
            }
    }
    
    var displayNameErrorLabel: Observable<Bool> {
        return Observable
            .combineLatest(nameFieldIsValid, nameTextFieldIsFocused) { isValid, isFocused in
                return !isValid && !isFocused
            }
    }
}
