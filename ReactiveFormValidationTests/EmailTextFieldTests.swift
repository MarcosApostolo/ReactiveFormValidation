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
        
        XCTAssertTrue(sut.errorLabel.isHidden)
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        XCTAssertTrue(sut.errorLabel.isHidden)
        
        sut.textField.resignFirstResponder()
        
        XCTAssertEqual(sut.textField.text?.isEmpty, true)
        XCTAssertFalse(sut.textField.isFirstResponder)
        XCTAssertFalse(sut.errorLabel.isHidden)
    }
    
    func test_invalidEmailAndNotFocused_displayErrorMessage() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.errorLabel.isHidden)
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        XCTAssertTrue(sut.errorLabel.isHidden)
        
        simulateTyping(on: sut.textField, value: "invalidEmail")
        
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.errorLabel.text, "Please type an valid email")
    }
    
    func test_validEmail_doesNotDisplayErrorMessage() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.errorLabel.isHidden)
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        XCTAssertTrue(sut.errorLabel.isHidden)
        
        simulateTyping(on: sut.textField, value: "email@email.com")
        
        XCTAssertTrue(sut.errorLabel.isHidden)
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TestHelperViewController {
        let sut = TestHelperViewController()
                
        return sut
    }

    private class TestHelperViewController: UIViewController {
        private(set) var textFieldController = EmailTextFieldController()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(textFieldController.textFieldView)
        }
        
        var errorLabel: UILabel {
            textFieldController.errorLabel
        }
        
        var textField: UITextField {
            textFieldController.textField
        }
    }
}
