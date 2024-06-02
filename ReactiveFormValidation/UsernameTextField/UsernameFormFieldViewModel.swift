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
    
    func onValidateUsername() {
        do {
            isLoading.onNext(true)
            
            let text = try self.textFieldValue.value()
            
            self.validateUniqueUsername?(text)
                .subscribe(onSuccess: { [weak self] status in
                    self?.usernameStatus.onNext(status)
                    self?.isLoading.onNext(false)
                }, onFailure: { [weak self] _ in
                    self?.isLoading.onNext(false)
                })
                .disposed(by: disposeBag)
        } catch {
            isLoading.onNext(false)
        }
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
}
