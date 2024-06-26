//
//  EmailTextFieldViewController.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 18/05/24.
//

import Foundation
import UIKit
import RxSwift

class EmailFormFieldController {
    private let disposeBag = DisposeBag()
    
    var viewModel = EmailFormFieldViewModel()
    
    private(set) lazy var formField: FormField = {
        return FormField()
    }()
    
    var textField: UITextField {
        formField.textField
    }
    
    var errorLabel: UILabel {
        formField.errorLabel
    }
    
    init() {
        bind()
    }
    
    func bind() {
        textField.textContentType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        
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
        
        formField.displayErrorLabel = viewModel.displayErrorLabel
        formField.errorMessage = viewModel.errorMessage
        
        textField.placeholder = viewModel.emailTextFieldPlaceholder
    }
    
}
