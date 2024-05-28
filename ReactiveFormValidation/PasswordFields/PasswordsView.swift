//
//  PasswordsView.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 24/05/24.
//

import UIKit

class PasswordView: UIView {
    private(set) lazy var newPasswordTextField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private(set) lazy var newPasswordVisibilityButton = PasswordVisibilityButton()
    private(set) lazy var confirmPasswordVisibilityButton = PasswordVisibilityButton()
    
    private(set) lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
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
        confirmPasswordTextField.rightView = confirmPasswordVisibilityButton
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
