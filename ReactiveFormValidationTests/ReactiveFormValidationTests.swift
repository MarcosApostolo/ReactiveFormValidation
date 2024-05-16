//
//  ReactiveFormValidationTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 15/05/24.
//

import XCTest
import UIKit
@testable import ReactiveFormValidation

final class ReactiveFormValidationTests: XCTestCase {
    func test_invalidNameFieldAndNotFocused_displayErrorMessage_disablesSubmitButton() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.submitButton.isEnabled)
        XCTAssertTrue(sut.nameErrorLabel.isHidden)
        
        sut.nameTextField.becomeFirstResponder()
        
        XCTAssertTrue(sut.nameTextField.isFirstResponder)
        XCTAssertFalse(sut.submitButton.isEnabled)
        XCTAssertTrue(sut.nameErrorLabel.isHidden)
        
        sut.nameTextField.resignFirstResponder()
        
        XCTAssertEqual(sut.nameTextField.text?.isEmpty, true)
        XCTAssertFalse(sut.nameTextField.isFirstResponder)
        XCTAssertFalse(sut.submitButton.isEnabled)
        XCTAssertFalse(sut.nameErrorLabel.isHidden)
    }
    
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
    
    // MARK: Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> ViewController {
        let sut = UIComposer.makeView()
        
        checkForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    func simulateTyping(on textField: UITextField, value: String) {
        textField.text = value
        textField.sendActions(for: .editingChanged)
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

extension ViewController {
    var nameErrorLabel: UILabel {
        self.nameTextFieldController.nameErrorLabel
    }
    
    var nameTextField: UITextField {
        self.nameTextFieldController.nameTextField
    }
}
