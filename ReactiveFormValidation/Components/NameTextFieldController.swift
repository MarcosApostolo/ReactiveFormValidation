//
//  NameTextFieldController.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import Foundation
import UIKit
import RxSwift

class NameTextFieldController: UIView {
    private let disposeBag = DisposeBag()
    
    let viewModel = NameTextFieldViewModel()
    
    private(set) lazy var nameTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    private(set) lazy var nameErrorLabel: UILabel = {
        let label = UILabel()
                
        label.text = "Name is Required!"
        label.isHidden = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameTextField)
        addSubview(nameErrorLabel)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            nameTextField.topAnchor.constraint(equalTo: topAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            nameErrorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nameErrorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            nameErrorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            nameErrorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        bind()
    }
    
    func bind() {
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.nameTextFieldValue)
            .disposed(by: disposeBag)
        
        nameTextField.rx
            .controlEvent(.editingDidBegin)
            .map { true }
            .bind(to: viewModel.nameTextFieldIsTouched)
            .disposed(by: disposeBag)
        
        nameTextField.rx
            .controlEvent(.editingDidBegin)
            .map { true }
            .bind(to: viewModel.nameTextFieldIsFocused)
            .disposed(by: disposeBag)
        
        nameTextField.rx
            .controlEvent(.editingDidEnd)
            .map { false }
            .bind(to: viewModel.nameTextFieldIsFocused)
            .disposed(by: disposeBag)
        
        viewModel
            .displayNameErrorLabel
            .skip(1)
            .map { !$0 }
            .bind(to: nameErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}
