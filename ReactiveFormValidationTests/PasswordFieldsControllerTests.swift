//
//  PasswordFieldsControllerTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 21/05/24.
//

import XCTest
@testable import ReactiveFormValidation

final class PasswordFieldsControllerTests: XCTestCase {
    func test_emptyOrLessthanMinLengthPassword_onNewPasswordField_displayMinLengthErrorMessage() {
        let sut = makeSUT()
                
        sut.loadViewIfNeeded()
        
        assertInitialState(sut.textFieldController)
        
        simulateTyping(on: sut.formField.newPasswordTextField, value: "")
        
        assertErrorOnNewPassword(sut.textFieldController, hasError: "Password length must be at least 8 characters")
        
        simulateTyping(on: sut.formField.newPasswordTextField, value: "1234567")
        
        assertErrorOnNewPassword(sut.textFieldController, hasError: "Password length must be at least 8 characters")
    }
    
    func test_moreThanMaxLengthPassword_displayMaxLengthErrorMessage() {
        let sut = makeSUT()
        
        let passwordEqualToMaxLength = "0123456789012345"
        let passwordWithMoreThanMaxLength = "very very very long password"
                
        sut.loadViewIfNeeded()
        
        assertInitialState(sut.textFieldController)
        
        simulateTyping(on: sut.formField.newPasswordTextField, value: passwordWithMoreThanMaxLength)
        
        assertErrorOnNewPassword(sut.textFieldController, hasError: "Password length must be no longer than 16 characters")
        
        simulateTyping(on: sut.formField.newPasswordTextField, value: passwordEqualToMaxLength)
        simulateTyping(on: sut.formField.confirmPasswordTextField, value: passwordEqualToMaxLength)
        
        assertNoErrorOn(sut.textFieldController)
    }
    
    func test_unmatchingPasswords_displayUnmatchingErrorMessage() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        assertInitialState(sut.textFieldController)
        
        simulateTyping(on: sut.formField.newPasswordTextField, value: "12345678")
        
        simulateTyping(on: sut.formField.confirmPasswordTextField, value: "123456789")
        
        assertErrorOnBothTextFields(sut.textFieldController, hasError: "Passwords don't match.")
    }
    
    func test_passwordsAreValid_doesNotDisplayErrorMessage() {
        let sut = makeSUT()
                
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        simulateTyping(on: sut.formField.newPasswordTextField, value: "12345678")
        simulateTyping(on: sut.formField.confirmPasswordTextField, value: "12345678")
        
        assertNoErrorOn(sut.textFieldController)
    }
    
    func test_onNewPasswordButtonTap_displayPassword() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.formField.newPasswordTextField.isSecureTextEntry)
        XCTAssertTrue(sut.formField.confirmPasswordTextField.isSecureTextEntry)
        
        sut.toggleNewPasswordVisibility()
        
        XCTAssertFalse(sut.formField.newPasswordTextField.isSecureTextEntry)
        
        sut.toggleConfirmPasswordVisibility()
        
        XCTAssertFalse(sut.formField.confirmPasswordTextField.isSecureTextEntry)
    }
    
    func test_initiallyWithUnfocusedStateOnTextField() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.formField.unfocusedStyleIsAppliedOnNewPasswordTextField)
        XCTAssertTrue(sut.formField.unfocusedStyleIsAppliedOnConfirmPasswordTextField)
    }
    
    func test_whenNewPasswordFocused_displayFocusedStyle() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        sut.formField.newPasswordTextField.becomeFirstResponder()
        
        XCTAssertTrue(sut.formField.focusedStyleIsAppliedOnNewPasswordTextField)
        XCTAssertTrue(sut.formField.unfocusedStyleIsAppliedOnConfirmPasswordTextField)
    }
    
    func test_whenConfirmPasswordFocused_displayFocusedStyle() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        sut.formField.confirmPasswordTextField.becomeFirstResponder()
        
        XCTAssertTrue(sut.formField.unfocusedStyleIsAppliedOnNewPasswordTextField)
        XCTAssertTrue(sut.formField.focusedStyleIsAppliedOnConfirmPasswordTextField)
    }
        
    // MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TestHelperViewController {
        let sut = TestHelperViewController()
                
        return sut
    }
    
    private func assertInitialState(_ sut: PasswordFieldsController, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertFalse(sut.passwordFormField.errorIsAppliedOnNewPasswordTextField, file: file, line: line)
        XCTAssertFalse(sut.passwordFormField.errorIsAppliedOnConfirmPasswordTextField, file: file, line: line)
    }
    
    private func assertErrorOnNewPassword(_ sut: PasswordFieldsController, hasError error: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertEqual(sut.errorLabel.text, error, file: file, line: line)
        XCTAssertTrue(sut.passwordFormField.errorIsAppliedOnNewPasswordTextField, file: file, line: line)
        XCTAssertFalse(sut.passwordFormField.errorIsAppliedOnConfirmPasswordTextField, file: file, line: line)
    }
    
    private func assertErrorOnBothTextFields(_ sut: PasswordFieldsController, hasError error: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertEqual(sut.errorLabel.text, error, file: file, line: line)
        XCTAssertTrue(sut.passwordFormField.errorIsAppliedOnNewPasswordTextField, file: file, line: line)
        XCTAssertTrue(sut.passwordFormField.errorIsAppliedOnConfirmPasswordTextField, file: file, line: line)
    }
    
    private func assertThat(_ sut: PasswordFieldsController, hasError error: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertEqual(sut.errorLabel.text, error, file: file, line: line)
        XCTAssertTrue(sut.passwordFormField.errorIsAppliedOnNewPasswordTextField, file: file, line: line)
    }
    
    private func assertNoErrorOn(_ sut: PasswordFieldsController, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertFalse(sut.passwordFormField.errorIsAppliedOnNewPasswordTextField, file: file, line: line)
        XCTAssertFalse(sut.passwordFormField.errorIsAppliedOnConfirmPasswordTextField, file: file, line: line)
    }
    
    private class TestHelperViewController: UIViewController {
        private(set) var textFieldController = PasswordFieldsController()
        
        override func viewDidLoad() {
            super.viewDidLoad()

            view.addSubview(textFieldController.passwordFormField)
        }
        
        var formField: PasswordFormField {
            return textFieldController.passwordFormField
        }
        
        func toggleConfirmPasswordVisibility() {
            textFieldController.confirmPasswordVisibilityButton.sendActions(for: .touchUpInside)
        }
        
        func toggleNewPasswordVisibility() {
            textFieldController.newPasswordVisibilityButton.sendActions(for: .touchUpInside)
        }
    }
}


private extension PasswordFormField {
    var unfocusedStyleIsAppliedOnNewPasswordTextField: Bool {
        newPasswordTextField.layer.borderWidth == 0.25
    }
    
    var focusedStyleIsAppliedOnNewPasswordTextField: Bool {
        newPasswordTextField.layer.borderWidth == 1
    }
    
    var unfocusedStyleIsAppliedOnConfirmPasswordTextField: Bool {
        confirmPasswordTextField.layer.borderWidth == 0.25
    }
    
    var focusedStyleIsAppliedOnConfirmPasswordTextField: Bool {
        confirmPasswordTextField.layer.borderWidth == 1
    }
    
    var errorIsAppliedOnNewPasswordTextField: Bool {
        newPasswordTextField.layer.borderColor == UIColor.red.cgColor
    }
    
    var errorIsAppliedOnConfirmPasswordTextField: Bool {
        confirmPasswordTextField.layer.borderColor == UIColor.red.cgColor
    }
    
    var validStyleIsAppliedOnNewPasswordTextField: Bool {
        newPasswordTextField.layer.borderColor == UIColor.blue.cgColor
    }
    
    var validStyleIsAppliedOnConfirmPasswordTextField: Bool {
        confirmPasswordTextField.layer.borderColor == UIColor.blue.cgColor
    }
}
