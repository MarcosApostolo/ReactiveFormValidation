//
//  FormFieldTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 31/05/24.
//

import XCTest
import RxSwift
@testable import ReactiveFormValidation

final class FormFieldTests: XCTestCase {
    func test_initiallyWithUnfocusedStateOnTextField() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.formField.unfocusedStyleIsApplied)
    }
    
    func test_whenFocused_displayFocusedStyleOnTextField() {
        let sut = makeSUT()
        
        putInViewHierarchy(sut)
        
        sut.loadViewIfNeeded()
        
        sut.formField.textField.becomeFirstResponder()
        
        XCTAssertTrue(sut.formField.focusedStyleIsApplied)
        
        sut.formField.textField.resignFirstResponder()
        
        XCTAssertTrue(sut.formField.unfocusedStyleIsApplied)
    }
    
    func test_withError_displayErrorStyleOnTextField() {
        let sut = makeSUT()
                
        sut.loadViewIfNeeded()
        
        sut.formField.displayErrorLabel = Observable<Bool>.create({ observer in
            observer.onNext(true)
            
            return Disposables.create()
        })
        
        XCTAssertTrue(sut.formField.errorStyleIsApplied)
    }
    
    func test_withoutError_displayValidStyleOnTextField() {
        let sut = makeSUT()
                
        sut.loadViewIfNeeded()
        
        sut.formField.displayErrorLabel = Observable<Bool>.create({ observer in
            observer.onNext(false)
            
            return Disposables.create()
        })
        
        XCTAssertTrue(sut.formField.validStyleIsApplied)
    }

    // MARK: Helpers
    private func makeSUT() -> TestHelperViewController {
        let sut = TestHelperViewController()
        
        return sut
    }

    private class TestHelperViewController: UIViewController {
        private(set) var formField = FormField()
        
        override func viewDidLoad() {
            super.viewDidLoad()

            view.addSubview(formField)
        }
    }
}

private extension FormField {
    var focusedStyleIsApplied: Bool {
        textField.layer.borderWidth == 1
    }
    
    var unfocusedStyleIsApplied: Bool {
        textField.layer.borderWidth == 0.25
    }
    
    var errorStyleIsApplied: Bool {
        textField.layer.borderColor == UIColor.red.cgColor
    }
    
    var validStyleIsApplied: Bool {
        textField.layer.borderColor == UIColor.blue.cgColor
    }
}
