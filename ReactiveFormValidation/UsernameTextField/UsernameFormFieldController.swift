//
//  UsernameTextFieldController.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 19/05/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class UsernameFormFieldController {
    private let disposeBag = DisposeBag()
    
    var viewModel: UsernameFormFieldViewModel? {
        didSet {
            bind()
        }
    }
    
    private(set) lazy var formField: FormField = {
        return FormField()
    }()
    
    private(set) lazy var validateUsernameButton: ValidateUsernameButton = {
        ValidateUsernameButton()
    }()
    
    var textField: UITextField {
        formField.textField
    }
    
    var errorLabel: UILabel {
        formField.errorLabel
    }
    
    init() {
        formField.textField.rightView = validateUsernameButton
        formField.textField.rightViewMode = .always
    }
    
    func bind() {
        guard let viewModel = viewModel else {
            return
        }
        
        textField.placeholder = viewModel.textFieldPlaceholder
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        textField.rx.text.orEmpty
            .bind(to: viewModel.textFieldValue)
            .disposed(by: disposeBag)

        textField.rx
            .controlEvent(.editingDidBegin)
            .map { true }
            .bind(to: viewModel.textFieldIsTouched)
            .disposed(by: disposeBag)

        textField.rx
            .controlEvent(.editingDidBegin)
            .map { true }
            .bind(to: viewModel.textFieldIsFocused)
            .disposed(by: disposeBag)

        textField.rx
            .controlEvent(.editingDidEnd)
            .map { false }
            .bind(to: viewModel.textFieldIsFocused)
            .disposed(by: disposeBag)
        
        formField.displayErrorLabel = Observable.merge([viewModel.displayErrorLabel, viewModel.displayUsernameStatusError])
        
        formField.errorMessage = Observable.merge([
            viewModel.errorMessage,
            viewModel.usernameError
        ])
        
        validateUsernameButton.rx
            .tap
            .subscribe(onNext: { viewModel.onValidateUsername() })
            .disposed(by: disposeBag)
        
        viewModel
            .isLoading
            .skip(1)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.validateUsernameButton.startLoading()
                } else {
                    self?.validateUsernameButton.stopLoading()
                }
        })
        .disposed(by: disposeBag)
    }
    
}

