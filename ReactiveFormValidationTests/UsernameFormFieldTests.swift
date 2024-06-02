//
//  UsernameTextFieldTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 19/05/24.
//

import XCTest
import RxSwift
@testable import ReactiveFormValidation

final class UsernameFormFieldTests: XCTestCase {    
    private let disposeBag = DisposeBag()
    
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
    
    func test_moreThan32Characters_displayErrorMessage() {        
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        simulateTyping(on: sut.textField, value: "username with more than thirty two characters")
                        
        assertThat(sut.textFieldController, hasError: "Username too long! Must have less than 32 characters.")
    }
    
    func test_onNonUniqueUsername_displayErrorMessage() {
        let single = Single<UsernameStatus>.create(subscribe: { single in
            single(.success(.used))
            
            return Disposables.create()
        })

        let sut = makeSUT(validateUniqueUsername: { _ in
            return single
        })
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        simulateTyping(on: sut.textField, value: "non unique username")
        
        sut.usernameButton.sendActions(for: .touchUpInside)
                  
        assertThat(sut.textFieldController, hasError: "Username is already used.")
    }
    
    func test_onUniqueUsername_doesNotDisplayErrorMessage() {
        let single = Single<UsernameStatus>.create(subscribe: { single in
            single(.success(.unused))
            
            return Disposables.create()
        })

        let sut = makeSUT(validateUniqueUsername: { _ in
            return single
        })
        
        sut.loadViewIfNeeded()
        
        assertNoErrorOn(sut.textFieldController)
        
        simulateTyping(on: sut.textField, value: "unique username")
        
        sut.usernameButton.sendActions(for: .touchUpInside)
                  
        assertNoErrorOn(sut.textFieldController)
    }
    
    func test_onUniqueValidation_displayLoading() {
        let sut = TestHelperViewController()
        
        let viewModel = UsernameFormFieldViewModel()
        
        sut.textFieldController.viewModel.validateUniqueUsername = { _ in
            Single<UsernameStatus>.create(subscribe: { single in
                XCTAssertTrue(sut.loadingIndicator.isAnimating)
                
                single(.success(.unused))
                
                return Disposables.create {
                    XCTAssertFalse(sut.loadingIndicator.isAnimating)
                }
            })
        }
        
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.loadingIndicator.isAnimating)
        
        simulateTyping(on: sut.textField, value: "unique username")
        sut.usernameButton.sendActions(for: .touchUpInside)
    }
    
    func test_correctPropertiesOnTextField() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.textField.autocapitalizationType, .none)
        XCTAssertEqual(sut.textField.autocorrectionType, .no)
    }

    // MARK: Helpers
    private func makeSUT(
        validateUniqueUsername: @escaping (String) -> Single<UsernameStatus> = { _ in .just(.unused) },
        file: StaticString = #file,
        line: UInt = #line
    ) -> TestHelperViewController {
        let sut = TestHelperViewController()
        
        let viewModel = UsernameFormFieldViewModel()
        
        sut.textFieldController.viewModel.validateUniqueUsername = validateUniqueUsername
        
        checkForMemoryLeaks(sut, file: file, line: line)
                        
        return sut
    }
    
    private func assertThat(_ sut: UsernameFormFieldController, hasError error: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(sut.errorLabel.isHidden, file: file, line: line)
        XCTAssertEqual(sut.errorLabel.text, error, file: file, line: line)
    }
    
    private func assertNoErrorOn(_ sut: UsernameFormFieldController, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(sut.errorLabel.isHidden, file: file, line: line)
    }
    
    private class TestHelperViewController: UIViewController {
        let textFieldController = UsernameFormFieldController()
                
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(textFieldController.formField)
            view.addSubview(textFieldController.validateUsernameButton)
        }
        
        var errorLabel: UILabel {
            textFieldController.errorLabel
        }
        
        var textField: UITextField {
            textFieldController.textField
        }
        
        var usernameButton: UIButton {
            textFieldController.validateUsernameButton
        }

        var loadingIndicator: UIActivityIndicatorView {
            textFieldController.validateUsernameButton.loadingIndicator
        }
    }
}
