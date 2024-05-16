//
//  ViewController.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    var viewModel: ViewModel? {
        didSet {
            bind()
        }
    }
    
    private let disposeBag = DisposeBag()
    
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
    private(set) lazy var submitButton: UIButton = {
        let button = UIButton()
        
        button.isEnabled = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(nameTextField)
        view.addSubview(nameErrorLabel)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            nameErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameErrorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
        ])
        
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func bind() {
        guard let viewModel = viewModel else {
            return
        }
        
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
        
        viewModel.formIsValid
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

