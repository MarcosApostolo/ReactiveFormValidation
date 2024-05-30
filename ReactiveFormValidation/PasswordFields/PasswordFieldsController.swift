//
//  PasswordFieldsController.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 21/05/24.
//

import Foundation
import UIKit
import RxSwift

class PasswordFieldsController {
    private let disposeBag = DisposeBag()
    
    let viewModel = PasswordFieldsViewModel()
    
    let passwordFormField = PasswordFormField()
    
    init() {
        bind()
    }
    
    func bind() {
        newPasswordTextField.placeholder = viewModel.newPasswordPlaceholder
        confirmPasswordTextField.placeholder = viewModel.confirmPasswordPlaceholder
        
        newPasswordTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.newPasswordValue)
            .disposed(by: disposeBag)

        newPasswordTextField.rx
            .controlEvent(.editingDidBegin)
            .map { true }
            .bind(to: viewModel.newPasswordValueIsTouched)
            .disposed(by: disposeBag)

        newPasswordTextField.rx
            .controlEvent(.editingDidBegin)
            .map { true }
            .bind(to: viewModel.newPasswordValueIsFocused)
            .disposed(by: disposeBag)

        newPasswordTextField.rx
            .controlEvent(.editingDidEnd)
            .map { false }
            .bind(to: viewModel.newPasswordValueIsFocused)
            .disposed(by: disposeBag)
        
        passwordFormField.displayLabelError = viewModel.displayErrorLabel
        passwordFormField.errorMessage = viewModel.errorMessage
        
        confirmPasswordTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.confirmPasswordValue)
            .disposed(by: disposeBag)
        
        viewModel
            .confirmPasswordVisibility
            .subscribe(onNext: { isSecure in
                self.confirmPasswordTextField.isSecureTextEntry = isSecure
            })
            .disposed(by: disposeBag)
        
        viewModel
            .newPasswordVisibility
            .subscribe(onNext: { isSecure in
                self.newPasswordTextField.isSecureTextEntry = isSecure
            })
            .disposed(by: disposeBag)
        
        viewModel
            .newPasswordVisibility
            .subscribe(onNext: { [weak self] isSecure in
                if isSecure {
                    self?.newPasswordVisibilityButton.hide()
                } else {
                    self?.newPasswordVisibilityButton.show()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .confirmPasswordVisibility
            .subscribe(onNext: { [weak self] isSecure in
                if isSecure {
                    self?.confirmPasswordVisibilityButton.hide()
                } else {
                    self?.confirmPasswordVisibilityButton.show()
                }
            })
            .disposed(by: disposeBag)
        
        confirmPasswordVisibilityButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                viewModel
                    .confirmPasswordVisibility
                    .onNext(!self.confirmPasswordTextField.isSecureTextEntry)
            })
            .disposed(by: disposeBag)
        
        newPasswordVisibilityButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                viewModel
                    .newPasswordVisibility
                    .onNext(!self.newPasswordTextField.isSecureTextEntry)
            })
            .disposed(by: disposeBag)
    }
}

extension PasswordFieldsController {
    var newPasswordTextField: UITextField {
        passwordFormField.newPasswordTextField
    }
    
    var errorLabel: UILabel {
        passwordFormField.errorLabel
    }
    
    var confirmPasswordTextField: UITextField {
        passwordFormField.confirmPasswordTextField
    }
    
    var newPasswordVisibilityButton: PasswordVisibilityButton {
        passwordFormField.newPasswordVisibilityButton
    }
    
    var confirmPasswordVisibilityButton: PasswordVisibilityButton {
        passwordFormField.confirmPasswordVisibilityButton
    }
}
