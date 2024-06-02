//
//  UsernameTextFieldViewModel.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 19/05/24.
//

import Foundation
import RxSwift

class UsernameFormFieldViewModel {
    private enum validationError: Error {
        case requestError
    }
    
    var textFieldValue = BehaviorSubject(value: "")
    var textFieldIsTouched = BehaviorSubject(value: false)
    var textFieldIsFocused = BehaviorSubject(value: false)
    var usernameStatus = PublishSubject<UsernameStatus>()
    var isLoading = BehaviorSubject(value: false)
    
    private let disposeBag = DisposeBag()
    
    var validateUniqueUsername: ((String) -> Single<UsernameStatus>)?

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
            .subscribe(on: MainScheduler.instance)
            .skip(1)
    }
    
    var errorMessage: Observable<String> {
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
    
    var displayUsernameStatusError: Observable<Bool> {
        return usernameStatus
            .map({ $0 == .used })
    }
    
    func onValidateUsername(username: String) -> Observable<UsernameStatus> {
        guard let validateUniqueUsername = validateUniqueUsername else {
            return Observable<UsernameStatus>.empty()
        }
        
        return validateUniqueUsername(username).asObservable()
    }
    
    var textFieldPlaceholder: String {
        "Username"
    }
    
    var usernameError: Observable<String> {
        usernameStatus
        .subscribe(on: MainScheduler.instance)
        .map({ status in
            status == .used ? "Username is already used." : ""
        })
    }
    
    func getTextFieldValue() -> Observable<String> {
        textFieldValue.asObservable()
    }
    
    func validate() -> Observable<Void> {
        fieldIsValid.asObservable()
            .filter({ $0 })
            .map({ _ in })
    }
    
    func startLoading() {
        isLoading.onNext(true)
    }
    
    func onValidateSuccess(status: UsernameStatus) {
        usernameStatus.onNext(status)
        isLoading.onNext(false)
    }
    
    func onValidateError(error: Error) {
        isLoading.onNext(false)
    }
    
    func onValidateComplete() {
        isLoading.onNext(false)
    }
}
