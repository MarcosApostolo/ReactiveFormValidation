//
//  FormSnapshotTests.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 24/05/24.
//

import XCTest
import FBSnapshotTestCase
@testable import ReactiveFormValidation

final class FormSnapshotTests: FBSnapshotTestCase {
    func test_formWithInitialState() {        
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        FBSnapshotVerifyView(sut.view, identifier: "FORM_WITH_INITIAL_STATE")
    }

    func test_withNameError() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        sut.simulateNameRequiredError()
        
        FBSnapshotVerifyView(sut.view, identifier: "FORM_WITH_NAME_ERROR")
    }
    
    // MARK: Helpers
    func makeSUT() -> FormViewController {
        let sut = FormUIComposer.makeView(validateUniqueUsername: { _ in
            .just(.unused)
        })
        
        return sut
    }
}

private extension FormViewController {
    func simulateNameRequiredError() {
        nameTextFieldController.viewModel.textFieldIsFocused.onNext(true)
        nameTextFieldController.viewModel.textFieldIsFocused.onNext(false)
    }
}
