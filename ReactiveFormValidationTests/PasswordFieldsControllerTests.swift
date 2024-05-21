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
        
        assertNoErrorOn(sut.textFieldController)
        
        simulateTyping(on: sut.newPasswordTextField, value: "")
        
        assertThat(sut.textFieldController, hasError: "Password length must be at least 8 characters")
        
        simulateTyping(on: sut.newPasswordTextField, value: "1234567")
        
        assertThat(sut.textFieldController, hasError: "Password length must be at least 8 characters")
    }
    
    func test_passwordWithMinLength_onNewPasswordField_doesNotDisplayMinLengthErrorMessage() {
        let sut = makeSUT()
                
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        simulateTyping(on: sut.newPasswordTextField, value: "12345678")
        
        assertNoErrorOn(sut.textFieldController)
    }
    
    func test_moreThanMaxLengthPassword_displayMaxLengthErrorMessage() {
        let sut = makeSUT()
        
        let passwordEqualToMaxLength = "0123456789012345"
        let passwordWithMoreThanMaxLength = "very very very long password"
                
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        simulateTyping(on: sut.newPasswordTextField, value: passwordWithMoreThanMaxLength)
        
        assertThat(sut.textFieldController, hasError: "Password length must be no longer than 16 characters")
        
        simulateTyping(on: sut.newPasswordTextField, value: passwordEqualToMaxLength)
        
        assertNoErrorOn(sut.textFieldController)
    }
        
    // MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TestHelperViewController {
        let sut = TestHelperViewController()
                
        return sut
    }
    
    private func assertThat(_ sut: PasswordFieldsController, hasError error: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertEqual(sut.errorLabel.text, error, file: file, line: line)
        
    }
    
    private func assertNoErrorOn(_ sut: PasswordFieldsController, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(sut.errorLabel.isHidden, file: file, line: line)
    }
    
    private class TestHelperViewController: UIViewController {
        private(set) var textFieldController = PasswordFieldsController()
        
        override func viewDidLoad() {
            super.viewDidLoad()

            view.addSubview(textFieldController.errorLabel)
            view.addSubview(textFieldController.newPasswordTextField)
        }
        
        var errorLabel: UILabel {
            textFieldController.errorLabel
        }
        
        var newPasswordTextField: UITextField {
            textFieldController.newPasswordTextField
        }
    }
}
