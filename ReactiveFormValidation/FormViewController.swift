//
//  ViewController.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import UIKit
import RxSwift

class FormViewController: UIViewController {
    var viewModel: FormViewModel? {
        didSet {
            bind()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private(set) var nameTextFieldController = NameTextFieldController()
    
    private(set) var emailTextFieldController = EmailTextFieldController()
    
    private(set) var usernameTextFieldController = UsernameTextFieldController()
    
    private(set) var passwordFieldsController = PasswordFieldsController()
    
    private(set) lazy var submitButton: UIButton = {
        let button = UIButton()
        
        button.isEnabled = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 24
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(nameTextFieldController.formField)
        view.addSubview(emailTextFieldController.formField)
        view.addSubview(usernameTextFieldController.formField)
        view.addSubview(passwordFieldsController.passwordsView)
        view.addSubview(submitButton)
        
        nameTextFieldController.formField.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldController.formField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextFieldController.formField.translatesAutoresizingMaskIntoConstraints = false
        passwordFieldsController.passwordsView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        NSLayoutConstraint.activate([
            nameTextFieldController.formField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameTextFieldController.formField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameTextFieldController.formField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
        ])
        
        NSLayoutConstraint.activate([
            emailTextFieldController.formField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailTextFieldController.formField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emailTextFieldController.formField.topAnchor.constraint(equalTo: nameTextFieldController.formField.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            usernameTextFieldController.formField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usernameTextFieldController.formField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameTextFieldController.formField.topAnchor.constraint(equalTo: emailTextFieldController.formField.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            passwordFieldsController.passwordsView.topAnchor.constraint(equalTo: usernameTextFieldController.formField.bottomAnchor),
            passwordFieldsController.passwordsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            passwordFieldsController.passwordsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            submitButton.heightAnchor.constraint(equalToConstant: 48)
        ])        
    }
    
    func bind() {
        guard let viewModel = viewModel else {
            return
        }
        
        nameTextFieldController.textField.rx
            .text
            .orEmpty
            .bind(to: viewModel.nameTextFieldValue)
            .disposed(by: disposeBag)
        
        nameTextFieldController.viewModel
            .fieldIsValid
            .bind(to: viewModel.nameTextFieldisValid)
            .disposed(by: disposeBag)
        
        emailTextFieldController.viewModel
            .fieldIsValid
            .bind(to: viewModel.emaiTextFieldisValid)
            .disposed(by: disposeBag)
        
        usernameTextFieldController.viewModel?
            .fieldsAreValid
            .bind(to: viewModel.usernameTextFieldIsValid)
            .disposed(by: disposeBag)
        
        passwordFieldsController.viewModel
            .passwordsAreValid
            .bind(to: viewModel.passwordFieldsAreValid)
            .disposed(by: disposeBag)
        
        viewModel.formIsValid
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.formIsValid
            .subscribe(onNext: { [weak self] isValid in
                self?.submitButton.alpha = isValid ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

