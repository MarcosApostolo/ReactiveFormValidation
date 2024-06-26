//
//  NameTextFieldTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 18/05/24.
//

import XCTest
import UIKit
@testable import ReactiveFormValidation

final class NameFormFieldTests: XCTestCase {
    func test_emptyNameFieldAndNotFocused_displayErrorMessage() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.formFieldController)
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        assertNoErrorOn(sut.formFieldController)
        
        sut.textField.resignFirstResponder()
        
        assertThat(sut.formFieldController, hasError: "Name is required!")
    }
    
    func test_focusedNameField_doesNotDislpayErrorMessage() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.formFieldController)
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        assertNoErrorOn(sut.formFieldController)
        
        sut.textField.resignFirstResponder()
        
        assertThat(sut.formFieldController, hasError: "Name is required!")
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        assertNoErrorOn(sut.formFieldController)
    }
    
    func test_correctPropertiesOnTextField() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.textField.textContentType, .name)
        XCTAssertEqual(sut.textField.autocapitalizationType, .words)
        XCTAssertEqual(sut.textField.autocorrectionType, .no)
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TestHelperViewController {
        let sut = TestHelperViewController()
                
        return sut
    }
    
    private func assertThat(_ sut: NameFormFieldController, hasError error: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertEqual(sut.errorLabel.text, error, file: file, line: line)
    }
    
    private func assertNoErrorOn(_ sut: NameFormFieldController, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(sut.errorLabel.isHidden, file: file, line: line)
    }

    private class TestHelperViewController: UIViewController {
        private(set) var formFieldController = NameFormFieldController()
        
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
