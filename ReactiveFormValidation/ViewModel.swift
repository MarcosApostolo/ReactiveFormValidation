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

    var formIsValid: Observable<Bool> {
        return nameTextFieldisValid.asObservable()
    }
    
    var nameTextFieldPlaceholder: String {
        "Name"
    }
    
    var nameErrorRequiredError: String {
        "Name is Required"
    }
}
