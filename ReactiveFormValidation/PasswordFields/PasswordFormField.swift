//
//  PasswordsView.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 24/05/24.
//

import UIKit
import RxSwift
import RxCocoa

class PasswordFormField: UIView {
    private let disposeBag = DisposeBag()

    private(set) lazy var newPasswordTextField: TextField = {
        let textField = TextField()
        
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private(set) lazy var confirmPasswordTextField: TextField = {
        let textField = TextField()
        
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private(set) lazy var newPasswordVisibilityButton = PasswordVisibilityButton()
    private(set) lazy var confirmPasswordVisibilityButton = PasswordVisibilityButton()
    
    private(set) lazy var errorLabel: UILabel = {
        let label = UILabel()
        
        label.isHidden = true
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .red
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(newPasswordTextField)
        addSubview(confirmPasswordTextField)
        addSubview(errorLabel)
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newPasswordTextField.topAnchor.constraint(equalTo: topAnchor),
            newPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  24),
            newPasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 22),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  24),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  24),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        newPasswordTextField.rightView = newPasswordVisibilityButton
        newPasswordTextField.rightViewMode = .always
        
        confirmPasswordTextField.rightView = confirmPasswordVisibilityButton
        confirmPasswordTextField.rightViewMode = .always
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func bind() {
        newPasswordTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                self?.newPasswordTextField.applyFocusedStyle()
            })
            .disposed(by: disposeBag)
        
        newPasswordTextField.rx
            .controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                self?.newPasswordTextField.applyUnfocusedStyle()
            })
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                self?.confirmPasswordTextField.applyFocusedStyle()
            })
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx
            .controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                self?.confirmPasswordTextField.applyUnfocusedStyle()
            })
            .disposed(by: disposeBag)
    }
}
