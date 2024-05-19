//
//  UsernameTextFieldTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 19/05/24.
//

import XCTest
@testable import ReactiveFormValidation

final class UsernameTextFieldTests: XCTestCase {
    func test_emptyUsernameAndNotFocused_displayRequiredErrorMessage() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        sut.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.textField.isFirstResponder)
        assertNoErrorOn(sut.textFieldController)
        
        sut.textField.resignFirstResponder()
        
        assertThat(sut.textFieldController, hasError: "Username is required!")
    }
    
    func test_moreThan16Characters_displayErrorMessage() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        simulateTyping(on: sut.textField, value: "username with more than thirty two characters")
        
        assertThat(sut.textFieldController, hasError: "Username too long! Must have less than 32 characters.")
    }

    // MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TestHelperViewController {
        let sut = TestHelperViewController()
                
        return sut
    }
    
    private func assertThat(_ sut: UsernameTextFieldController, hasError error: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertEqual(sut.errorLabel.text, error, file: file, line: line)
    }
    
    private func assertNoErrorOn(_ sut: UsernameTextFieldController) {
        XCTAssertTrue(sut.errorLabel.isHidden)
    }
    
    private class TestHelperViewController: UIViewController {
        private(set) var textFieldController = UsernameTextFieldController()
        
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
