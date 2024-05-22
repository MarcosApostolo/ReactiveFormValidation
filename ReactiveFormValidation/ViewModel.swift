//
//  ViewModel.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import Foundation
import RxSwift

class ViewModel {
    var nameTextFieldValue = BehaviorSubject(value: "")
    var nameTextFieldisValid = BehaviorSubject(value: false)
    var emaiTextFieldisValid = BehaviorSubject(value: false)
    var usernameTextFieldIsValid = BehaviorSubject(value: false)
    var passwordFieldsAreValid = BehaviorSubject(value: false)

    var formIsValid: Observable<Bool> {
        return Observable
            .combineLatest(
                nameTextFieldisValid,
                emaiTextFieldisValid,
                usernameTextFieldIsValid,
                passwordFieldsAreValid
            ) { $0 && $1 && $2 && $3 }
    }
}
