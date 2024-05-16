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
    
    // MARK: Helpers
    func makeSUT() -> ViewController {
        let sut = UIComposer.makeView()
        
        checkForMemoryLeaks(sut)
        
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
