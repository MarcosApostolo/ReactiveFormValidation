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
        button.setTitle("Continuar", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(nameTextFieldController.textFieldView)
        view.addSubview(emailTextFieldController.textFieldView)
        view.addSubview(usernameTextFieldController.textFieldView)
        view.addSubview(passwordFieldsController.passwordsView)
        view.addSubview(submitButton)
        
        nameTextFieldController.textFieldView.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldController.textFieldView.translatesAutoresizingMaskIntoConstraints = false
        usernameTextFieldController.textFieldView.translatesAutoresizingMaskIntoConstraints = false
        passwordFieldsController.passwordsView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        NSLayoutConstraint.activate([
            nameTextFieldController.textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameTextFieldController.textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameTextFieldController.textFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
        ])
        
        NSLayoutConstraint.activate([
            emailTextFieldController.textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailTextFieldController.textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emailTextFieldController.textFieldView.topAnchor.constraint(equalTo: nameTextFieldController.textFieldView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            usernameTextFieldController.textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usernameTextFieldController.textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameTextFieldController.textFieldView.topAnchor.constraint(equalTo: emailTextFieldController.textFieldView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            passwordFieldsController.passwordsView.topAnchor.constraint(equalTo: usernameTextFieldController.textFieldView.bottomAnchor),
            passwordFieldsController.passwordsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            passwordFieldsController.passwordsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
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

