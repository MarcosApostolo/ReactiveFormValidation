//
//  FormSnapshotTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 24/05/24.
//

import XCTest
import FBSnapshotTestCase
import RxSwift
@testable import ReactiveFormValidation

final class FormSnapshotTests: FBSnapshotTestCase {
    func test_formWithInitialState() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "INITIAL_STATE_LIGHT")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "INITIAL_STATE_DARK")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light, device: .iPhoneSE)), identifier: "INITIAL_STATE_IPHONE_SE")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light, device: .iPhoneSE1)), identifier: "INITIAL_STATE_IPHONE_SE_1STGEN")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light, device: .iPhone15ProMax)), identifier: "INITIAL_STATE_IPHONE_PRO_MAX")
    }

    func test_withNameRequiredError() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        sut.simulateNameRequiredError()

        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "NAME_REQUIRED_ERROR_LIGHT")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "NAME_REQUIRED_ERROR_DARK")
    }
    
    func test_withEmailRequiredError() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        sut.simulateEmailRequiredError()
        
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "EMAIL_REQUIRED_ERROR_LIGHT")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "EMAIL_REQUIRED_ERROR_DARK")
    }
    
    func test_withInvalidEmailError() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        sut.simulateInvalidEmailError()
        
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "INVALID_EMAIL_ERROR_LIGHT")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "INVALID_EMAIL_ERROR_DARK")
    }
    
    func test_withUsernameRequiredError() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        sut.simulateUsernameRequiredError()
        
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "USERNAME_REQUIRED_ERROR_LIGHT")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "USERNAME_REQUIRED_ERROR_DARK")
    }
    
    func test_withLongUsernameError() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        sut.simulateLongUsernameError()
        
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "LONG_USERNAME_ERROR_LIGHT")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "LONG_USERNAME_ERROR_DARK")
    }
    
    func test_withNonUniqueUsernameError() {
        let sut = makeSUT(validateUniqueUsername: { _ in
            .just(.used)
        })
        
        sut.loadViewIfNeeded()
        
        sut.simulateNonUniqueUsernameError()
        
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "NON_UNIQUE_USERNAME_ERROR_LIGHT")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "NON_UNIQUE_USERNAME_ERROR_DARK")
    }
    
    func test_withUsernameValidationLoading() {
        let sut = makeSUT(validateUniqueUsername: { _ in
            .never()
        })
        
        sut.loadViewIfNeeded()
        
        sut.simulateNonUniqueUsernameError()
        
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "USERNAME_VALIDATION_LOADING_LIGHT")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "USERNAME_VALIDATION_LOADING_DARK")
    }
//    
//    func test_withPasswordMinLengthError() {
//        let sut = makeSUT()
//        
//        sut.loadViewIfNeeded()
//        
//        sut.simulatePasswordMinLengthError()
//        
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "PASSWORD_MIN_LENGTH_ERROR_LIGHT")
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "PASSWORD_MIN_LENGTH_ERROR_DARK")
//    }
//    
//    func test_withPasswordMaxLengthError() {
//        let sut = makeSUT()
//        
//        sut.loadViewIfNeeded()
//        
//        sut.simulatePasswordMaxLengthError()
//        
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "PASSWORD_MAX_LENGTH_ERROR_LIGHT")
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "PASSWORD_MAX_LENGTH_ERROR_DARK")
//    }
//    
//    func test_withUnmatchingPasswordsError() {
//        let sut = makeSUT()
//        
//        sut.loadViewIfNeeded()
//        
//        sut.simulateUnmatchingPasswordError()
//        
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "UNMATCHING_PASSWORD_ERROR_LIGHT")
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "UNMATCHING_PASSWORD_ERROR_DARK")
//    }
//    
//    func test_withPasswordsVisible() {
//        let sut = makeSUT()
//        
//        sut.loadViewIfNeeded()
//        
//        sut.makePasswordsVisible()
//        
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "PASSWORDS_VISIBLE_LIGHT")
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "PASSWORDS_VISIBLE_DARK")
//    }
//    
//    func test_withValidForm() {
//        let sut = makeSUT()
//        
//        sut.loadViewIfNeeded()
//        
//        sut.simulateValidForm()
//        
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "VALID_FORM_LIGHT")
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "VALID_FORM_DARK")
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light, device: .iPhoneSE)), identifier: "VALID_FORM_IPHONE_SE")
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light, device: .iPhoneSE1)), identifier: "VALID_FORM_IPHONE_SE_1STGEN")
//        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light, device: .iPhone15ProMax)), identifier: "VALID_FORM_IPHONE_PRO_MAX")
//    }
//    
    // MARK: Helpers
    func makeSUT(
        validateUniqueUsername: @escaping (String) -> Single<UsernameStatus> = { _ in .just(.unused) }
    ) -> FormViewController {
        let sut = FormUIComposer.makeView(validateUniqueUsername: validateUniqueUsername)
        
        return sut
    }
    
    
    func snapshotConfig(_ vc: FormViewController, configuration: SnapshotConfiguration) -> UIView {
        let _ = SnapshotWindow(configuration: configuration, root: vc)
        
        return vc.view
    }
}

private extension FormViewController {
    func simulateNameRequiredError() {
        nameFormFieldController.viewModel.textFieldIsFocused.onNext(true)
        nameFormFieldController.viewModel.textFieldIsFocused.onNext(false)
    }
    
    func simulateEmailRequiredError() {
        emailFormFieldController.viewModel.textFieldIsFocused.onNext(true)
        emailFormFieldController.viewModel.textFieldIsFocused.onNext(false)
    }
    
    func simulateInvalidEmailError() {
        simulateTyping(on: emailFormFieldController.textField, value: "invalid email")
    }
    
    func simulateUsernameRequiredError() {
        usernameFormFieldController.viewModel?.textFieldIsFocused.onNext(true)
        usernameFormFieldController.viewModel?.textFieldIsFocused.onNext(false)
    }
    
    func simulateLongUsernameError() {
        simulateTyping(on: usernameFormFieldController.textField, value: "username with more than thirty two characters")
    }
    
    func simulateNonUniqueUsernameError() {
        simulateTyping(on: usernameFormFieldController.textField, value: "non unique username")
        
        usernameFormFieldController.validateUsernameButton.sendActions(for: .touchUpInside)
    }
    
    func simulatePasswordMinLengthError() {
        simulateTyping(on: passwordFieldsController.newPasswordTextField, value: "12345")
    }
    
    func simulatePasswordMaxLengthError() {
        simulateTyping(on: passwordFieldsController.newPasswordTextField, value: "very very very long password")
    }
    
    func simulateUnmatchingPasswordError() {
        simulateTyping(on: passwordFieldsController.newPasswordTextField, value: "12345678")
        simulateTyping(on: passwordFieldsController.confirmPasswordTextField, value: "123456789")
    }
    
    func simulateValidForm() {
        simulateTyping(on: nameFormFieldController.textField, value: "A name")
        simulateTyping(on: emailFormFieldController.textField, value: "email@email.com")
        simulateTyping(on: usernameFormFieldController.textField, value: "a username")
        usernameFormFieldController.validateUsernameButton.sendActions(for: .touchUpInside)
        simulateTyping(on: passwordFieldsController.newPasswordTextField, value: "12345678")
        simulateTyping(on: passwordFieldsController.confirmPasswordTextField, value: "12345678")
    }
    
    func makePasswordsVisible() {
        simulateTyping(on: passwordFieldsController.newPasswordTextField, value: "12345678")
        simulateTyping(on: passwordFieldsController.confirmPasswordTextField, value: "12345678")
        passwordFieldsController.newPasswordVisibilityButton.sendActions(for: .touchUpInside)
        passwordFieldsController.confirmPasswordVisibilityButton.sendActions(for: .touchUpInside)
    }
    
    func simulateFocusedState() {
        nameFormFieldController.textField.becomeFirstResponder()
    }
}
