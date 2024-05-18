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
    
    func test_allFieldValid_enablesSubmitButton() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.submitButton.isEnabled)
        
        simulateTyping(on: sut.nameTextField, value: "any name")
        
        XCTAssertTrue(sut.submitButton.isEnabled)
    }
    
    // MARK: Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> ViewController {
        let sut = UIComposer.makeView()
        
        checkForMemoryLeaks(sut, file: file, line: line)
        
        return sut
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
        self.nameTextFieldController.errorLabel
    }
    
    var nameTextField: UITextField {
        self.nameTextFieldController.textField
    }
    
    var emailErrorLabel: UILabel {
        self.emailTextFieldController.errorLabel
    }
    
    var emailTextField: UITextField {
        self.emailTextFieldController.textField
    }
}
