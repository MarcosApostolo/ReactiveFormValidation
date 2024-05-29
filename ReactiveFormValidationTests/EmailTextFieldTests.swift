//
//  EmailTextFieldTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 15/05/24.
//

import XCTest
import UIKit
@testable import ReactiveFormValidation

final class EmailTextFieldTests: XCTestCase {
    func test_emptyEmailFieldAndNotFocused_displayErrorMessage() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        XCTAssertTrue(sut.errorLabel.isHidden)
        
        sut.textField.resignFirstResponder()
        
        assertThat(sut.textFieldController, hasError: "Email is required!")
        XCTAssertFalse(sut.textField.isFirstResponder)
    }
    
    func test_invalidEmailAndNotFocused_displayErrorMessage() {
        let sut = makeSUT()
                
        sut.loadViewIfNeeded()

        assertNoErrorOn(sut.textFieldController)
        
        simulateTyping(on: sut.textField, value: "invalidEmail")

        assertThat(sut.textFieldController, hasError: "Please type an valid email")
    }
    
    func test_validEmail_doesNotDisplayErrorMessage() {
        let sut = makeSUT()
                
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        simulateTyping(on: sut.textField, value: "email@email.com")
        
        assertNoErrorOn(sut.textFieldController)
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TestHelperViewController {
        let sut = TestHelperViewController()
                
        return sut
    }
    
    private func assertThat(_ sut: EmailTextFieldController, hasError error: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertEqual(sut.errorLabel.text, error, file: file, line: line)
        
    }
    
    private func assertNoErrorOn(_ sut: EmailTextFieldController) {
        XCTAssertTrue(sut.errorLabel.isHidden)
    }

    private class TestHelperViewController: UIViewController {
        private(set) var textFieldController = EmailTextFieldController()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(textFieldController.formField)
        }
        
        var errorLabel: UILabel {
            textFieldController.errorLabel
        }
        
        var textField: UITextField {
            textFieldController.textField
        }
    }
}
