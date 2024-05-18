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
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TestHelperViewController {
        let sut = TestHelperViewController()
                
        return sut
    }
    
    func putInViewHierarchy(_ vc: UIViewController) {
        let window: UIWindow? = UIWindow()
        
        window?.rootViewController = vc
        
        window?.addSubview(vc.view)
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
