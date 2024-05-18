//
//  TextFieldView.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import Foundation
import UIKit
import RxCocoa

class TextFieldView: UIView {
    private(set) lazy var textField: UITextField = {
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
        
        addSubview(textField)
        addSubview(errorLabel)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
