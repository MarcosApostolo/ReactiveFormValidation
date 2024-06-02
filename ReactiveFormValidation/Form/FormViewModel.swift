//
//  ViewModel.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import Foundation
import RxSwift

class FormViewModel {
    var nameTextFieldisValid = BehaviorSubject(value: false)
    var emaiTextFieldisValid = BehaviorSubject(value: false)
    var usernameTextFieldIsValid = BehaviorSubject(value: false)
    var passwordFieldsAreValid = BehaviorSubject(value: false)
    
    let registerService: (RegisterInfo) -> Single<Void>
    
    init(registerService: @escaping (RegisterInfo) -> Single<Void>) {
        self.registerService = registerService
    }

    var formIsValid: Observable<Bool> {
        return Observable
            .combineLatest(
                nameTextFieldisValid,
                emaiTextFieldisValid,
                usernameTextFieldIsValid,
                passwordFieldsAreValid
            ) { $0 && $1 && $2 && $3 }
    }
    
    var buttonLabel: String {
        "Continue"
    }
}
