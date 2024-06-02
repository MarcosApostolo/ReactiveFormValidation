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
    
    private(set) var nameFormFieldController = NameFormFieldController()
    
    private(set) var emailFormFieldController = EmailFormFieldController()
    
    private(set) var usernameFormFieldController = UsernameFormFieldController()
    
    private(set) var passwordFieldsController = PasswordFieldsController()
    
    private(set) lazy var submitButton: UIButton = {
        let button = UIButton()
        
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 24
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(nameFormFieldController.formField)
        view.addSubview(emailFormFieldController.formField)
        view.addSubview(usernameFormFieldController.formField)
        view.addSubview(passwordFieldsController.passwordFormField)
        view.addSubview(submitButton)
        
        nameFormFieldController.formField.translatesAutoresizingMaskIntoConstraints = false
        emailFormFieldController.formField.translatesAutoresizingMaskIntoConstraints = false
        usernameFormFieldController.formField.translatesAutoresizingMaskIntoConstraints = false
        passwordFieldsController.passwordFormField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        NSLayoutConstraint.activate([
            nameFormFieldController.formField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameFormFieldController.formField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameFormFieldController.formField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
        ])
        
        NSLayoutConstraint.activate([
            emailFormFieldController.formField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailFormFieldController.formField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emailFormFieldController.formField.topAnchor.constraint(equalTo: nameFormFieldController.formField.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            usernameFormFieldController.formField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usernameFormFieldController.formField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameFormFieldController.formField.topAnchor.constraint(equalTo: emailFormFieldController.formField.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            passwordFieldsController.passwordFormField.topAnchor.constraint(equalTo: usernameFormFieldController.formField.bottomAnchor),
            passwordFieldsController.passwordFormField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            passwordFieldsController.passwordFormField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            submitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func onNavigateToMain() {
        
    }
    
    func bind() {
        guard let viewModel = viewModel else {
            return
        }
        
        submitButton.setTitle(viewModel.buttonLabel, for: .normal)
        
        nameFormFieldController.viewModel
            .fieldIsValid
            .bind(to: viewModel.nameTextFieldisValid)
            .disposed(by: disposeBag)
        
        emailFormFieldController.viewModel
            .fieldIsValid
            .bind(to: viewModel.emaiTextFieldisValid)
            .disposed(by: disposeBag)
        
        usernameFormFieldController.viewModel
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
                
        submitButton.rx.tap
            .take(1)
            .flatMap(viewModel.validate)
            .flatMap({ [weak self] () -> Observable<RegisterInfo?> in
                guard let strongSelf = self else { return Observable.just(nil) }
                
                return strongSelf.getRegisterInfo()
            })
            .compactMap({ $0 })
            .subscribe(on: MainScheduler.instance)
            .flatMap(viewModel.registerService)
            .subscribe(onNext: { [weak self] in
                self?.onNavigateToMain()
            })
            .disposed(by: disposeBag)
    }
    
    private func getRegisterInfo() -> Observable<RegisterInfo?> {
        Observable.combineLatest(
            nameFormFieldController.viewModel.textFieldValue,
            emailFormFieldController.viewModel.textFieldValue,
            usernameFormFieldController.viewModel.textFieldValue,
            passwordFieldsController.viewModel.newPasswordValue
        )
        .map({ name, email, username, password in
            RegisterInfo(name: name, email: email, username: username, passsowrd: password)
        })
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

