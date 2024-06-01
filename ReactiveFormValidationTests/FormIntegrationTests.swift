//
//  ReactiveFormValidationTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 15/05/24.
//

import XCTest
import UIKit
import RxSwift
@testable import ReactiveFormValidation

final class FormIntegrationTests: XCTestCase {
    func test_tapOnView_dismissesKeyboard() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.nameTextField.isFirstResponder)
        
        sut.nameTextField.becomeFirstResponder()
        
        XCTAssertTrue(sut.nameTextField.isFirstResponder)
        
        sut.dismissKeyboard()
        
        XCTAssertFalse(sut.nameTextField.isFirstResponder)
    }
    
    func test_onLoad_submitButtonIsDisabled() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.submitButton.isEnabled)
    }
    
    func test_allFieldValid_enablesSubmitButton() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
                
        simulateTyping(on: sut.nameTextField, value: "any name")
        simulateTyping(on: sut.emailTextField, value: "email@email.com")
        simulateTyping(on: sut.usernameTextField, value: "unique username")
        simulateTyping(on: sut.newPasswordTextField, value: "12345678")
        simulateTyping(on: sut.confirmPasswordTextField, value: "12345678")
        sut.validateUsernameButton.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(sut.submitButton.isEnabled)
    }
    
    func test_anyInvalidField_disablesSubmitButton() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        simulateTyping(on: sut.nameTextField, value: "any name")
        simulateTyping(on: sut.emailTextField, value: "email@email.com")
        simulateTyping(on: sut.usernameTextField, value: "unique username")
        simulateTyping(on: sut.newPasswordTextField, value: "12345678")
        simulateTyping(on: sut.confirmPasswordTextField, value: "12345678")
        sut.validateUsernameButton.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(sut.submitButton.isEnabled)
        
        simulateTyping(on: sut.emailTextField, value: "invalid email")
        
        XCTAssertFalse(sut.submitButton.isEnabled)
    }
    
    // MARK: Helpers
    func makeSUT(
        validateUniqueUsername: @escaping (String) -> Single<UsernameStatus> = { _ in .just(.unused) },
        file: StaticString = #file,
        line: UInt = #line
    ) -> FormViewController {
        let sut = FormUIComposer.makeView(validateUniqueUsername: validateUniqueUsername)
        
        checkForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    func putInViewHierarchy(_ vc: UIViewController) {
        let window: UIWindow? = UIWindow()
        
        window?.rootViewController = vc
        
        window?.addSubview(vc.view)
    }
}


extension XCTestCase {
    func checkForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}

private extension FormViewController {
    var nameErrorLabel: UILabel {
        self.nameFormFieldController.errorLabel
    }
    
    var nameTextField: UITextField {
        self.nameFormFieldController.textField
    }
    
    var emailErrorLabel: UILabel {
        self.emailFormFieldController.errorLabel
    }
    
    var emailTextField: UITextField {
        self.emailFormFieldController.textField
    }
    
    var usernameTextField: UITextField {
        self.usernameFormFieldController.textField
    }
    
    var validateUsernameButton: UIButton {
        self.usernameFormFieldController.validateUsernameButton
    }
    
    var newPasswordTextField: UITextField {
        self.passwordFieldsController.newPasswordTextField
    }
    
    var confirmPasswordTextField: UITextField {
        self.passwordFieldsController.confirmPasswordTextField
    }
}
