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
    var usernameStatus = PublishSubject<UsernameStatus>()
    
    private let disposeBag = DisposeBag()
    
    var fieldIsValid: Observable<Bool> {
        return Observable
            .combineLatest(
                textFieldValue,
                textFieldIsTouched
            ) { value, isTouched in
                return isTouched && value.count <= 32 && !value.isEmpty
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
        .distinctUntilChanged()
    }
    
    var fieldsAreValid: Observable<Bool> {
        return Observable
            .combineLatest(
                fieldIsValid,
                usernameStatus.map({ $0 == .unused })
            ) { $0 && $1 }
            .distinctUntilChanged()
            .share()
    }

    var textFieldPlaceholder: String {
        "Username"
    }
    
    var usernameError: String {
        "Username is already used."
    }
}
