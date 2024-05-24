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
        
        return textField
    }()
    
    private(set) lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private(set) lazy var errorLabel: UILabel = {
        let label = UILabel()
        
        label.isHidden = true
        
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
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  24),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  24),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
