//
//  NameTextFieldTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 18/05/24.
//

import XCTest
import UIKit
@testable import ReactiveFormValidation

final class RefactoredNameTextFieldControllerTests: XCTestCase {
    func test_emptyNameFieldAndNotFocused_displayErrorMessage() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        assertNoErrorOn(sut.textFieldController)
        
        sut.textField.resignFirstResponder()
        
        assertThat(sut.textFieldController, hasError: "Name is required!")
    }
    
    func test_focusedNameField_doesNotDislpayErrorMessage() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        assertNoErrorOn(sut.textFieldController)
        
        sut.textField.resignFirstResponder()
        
        assertThat(sut.textFieldController, hasError: "Name is required!")
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        assertNoErrorOn(sut.textFieldController)
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TestHelperViewController {
        let sut = TestHelperViewController()
                
        return sut
    }
    
    private func assertThat(_ sut: RefactoredNameTextFieldController, hasError error: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertEqual(sut.errorLabel.text, error, file: file, line: line)
    }
    
    private func assertNoErrorOn(_ sut: RefactoredNameTextFieldController) {
        XCTAssertTrue(sut.errorLabel.isHidden)
    }

    private class TestHelperViewController: UIViewController {
        private(set) var textFieldController = RefactoredNameTextFieldController()
        
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
