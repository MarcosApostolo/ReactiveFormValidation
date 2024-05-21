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

class UsernameTextFieldController {
    private let disposeBag = DisposeBag()
    
    var viewModel = UsernameTextFieldViewModel()
    
    private(set) lazy var textFieldView: TextFieldView = {
        return TextFieldView()
    }()
    
    private(set) lazy var validateUsernameButton: UIButton = {
        UIButton()
    }()
    
    var textField: UITextField {
        textFieldView.textField
    }
    
    var errorLabel: UILabel {
        textFieldView.errorLabel
    }
    
    var validateUniqueUsername: ((String) -> Single<UsernameStatus>)? {
        didSet {
            bindValidateUsernameButton()
        }
    }
    
    init() {
        bind()
    }
    
    func bind() {
        textField.placeholder = viewModel.textFieldPlaceholder
        
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
            .subscribe(on: MainScheduler.instance)
            .skip(1)
            .map { !$0 }
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .errorLabel
            .subscribe(on: MainScheduler.instance)
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindValidateUsernameButton() {
        guard let validateUniqueUsername = validateUniqueUsername else {
            return
        }
        
        validateUsernameButton.rx
            .tap
            .flatMap({ _ in
                return validateUniqueUsername("")
            })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { status in
                if status == .used {
                    print("RxSwift passou aqui")
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Username is already used."
                } else {
                    self.errorLabel.isHidden = true
                    self.errorLabel.text = nil
                }
            })
            .disposed(by: disposeBag)
    }
    
}

