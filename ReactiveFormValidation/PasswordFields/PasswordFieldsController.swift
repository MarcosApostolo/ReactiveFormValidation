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
    
    private(set) lazy var newPasswordTextField: UITextField = {
        UITextField()
    }()
    
    private(set) lazy var confirmPasswordTextField: UITextField = {
        UITextField()
    }()
    
    private(set) lazy var errorLabel: UILabel = {
        let label = UILabel()
        
        label.isHidden = true
        
        return label
    }()
    
    init() {
        bind()
    }
    
    func bind() {
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

        viewModel
            .displayErrorLabel
            .skip(1)
            .map { !$0 }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .errorLabel
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.confirmPasswordValue)
            .disposed(by: disposeBag)
    }
}
