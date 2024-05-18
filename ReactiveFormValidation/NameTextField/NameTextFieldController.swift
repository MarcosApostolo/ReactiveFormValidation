//
//  NameTextFieldController.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 18/05/24.
//

import Foundation
import UIKit
import RxSwift

class NameTextFieldController {
    private let disposeBag = DisposeBag()
    
    var viewModel = NameTextFieldViewModel()
    
    private(set) lazy var textFieldView: TextFieldView = {
        return TextFieldView()
    }()
    
    var textField: UITextField {
        textFieldView.textField
    }
    
    var errorLabel: UILabel {
        textFieldView.errorLabel
    }
    
    init() {
        bind()
    }
    
    func bind() {
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

        viewModel
            .displayErrorLabel
            .skip(1)
            .map { !$0 }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}
