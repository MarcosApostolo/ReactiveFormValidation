//
//  EmailTextFieldTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 15/05/24.
//

import XCTest
import UIKit
@testable import ReactiveFormValidation

final class EmailFormFieldTests: XCTestCase {
    func test_emptyEmailFieldAndNotFocused_displayErrorMessage() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.formFieldController)
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        XCTAssertTrue(sut.errorLabel.isHidden)
        
        sut.textField.resignFirstResponder()
        
        assertThat(sut.formFieldController, hasError: "Email is required!")
        XCTAssertFalse(sut.textField.isFirstResponder)
    }
    
    func test_invalidEmailAndNotFocused_displayErrorMessage() {
        let sut = makeSUT()
                
        sut.loadViewIfNeeded()

        assertNoErrorOn(sut.formFieldController)
        
        simulateTyping(on: sut.textField, value: "invalidEmail")

        assertThat(sut.formFieldController, hasError: "Please type an valid email")
    }
    
    func test_validEmail_doesNotDisplayErrorMessage() {
        let sut = makeSUT()
                
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.formFieldController)
        
        simulateTyping(on: sut.textField, value: "email@email.com")
        
        assertNoErrorOn(sut.formFieldController)
    }
    
    func test_correctPropertiesOnTextField() {
        let sut = makeSUT()
                
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.textField.textContentType, .emailAddress)
        XCTAssertEqual(sut.textField.autocapitalizationType, .none)
        XCTAssertEqual(sut.textField.autocorrectionType, .no)
        XCTAssertEqual(sut.textField.keyboardType, .emailAddress)
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TestHelperViewController {
        let sut = TestHelperViewController()
                
        return sut
    }
    
    private func assertThat(_ sut: EmailFormFieldController, hasError error: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertEqual(sut.errorLabel.text, error, file: file, line: line)
        
    }
    
    private func assertNoErrorOn(_ sut: EmailFormFieldController) {
        XCTAssertTrue(sut.errorLabel.isHidden)
    }

    private class TestHelperViewController: UIViewController {
        private(set) var formFieldController = EmailFormFieldController()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(formFieldController.formField)
        }
        
        var errorLabel: UILabel {
            formFieldController.errorLabel
        }
        
        var textField: UITextField {
            formFieldController.textField
        }
    }
}
