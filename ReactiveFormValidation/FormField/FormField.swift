//
//  TextFieldView.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class FormField: UIView {
    private let disposeBag = DisposeBag()
    
    var displayErrorLabel: Observable<Bool>? {
        didSet {
            bindDisplayErrorLabel()
        }
    }
    var errorMessage: Observable<String>? {
        didSet {
            bindErrorMessage()
        }
    }
        
    private(set) lazy var textField: TextField = {
        let textField = TextField()
                
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
        
        addSubview(textField)
        addSubview(errorLabel)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            textField.topAnchor.constraint(equalTo: topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 12)
        ])
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func bind() {
        textField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                self?.textField.applyFocusedStyle()
            })
            .disposed(by: disposeBag)
        
        textField.rx
            .controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                self?.textField.applyUnfocusedStyle()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDisplayErrorLabel() {
        displayErrorLabel?
            .subscribe(onNext: { [weak self] hasError in
                if hasError {
                    self?.textField.applyErrorStyle()
                } else {
                    self?.textField.applyValidStyle()
                }
                
                self?.errorLabel.isHidden = !hasError
            })
            .disposed(by: disposeBag)
    }
    
    private func bindErrorMessage() {
        errorMessage?
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
