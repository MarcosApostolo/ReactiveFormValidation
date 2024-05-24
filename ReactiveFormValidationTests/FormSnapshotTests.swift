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

    
    // MARK: Helpers
    func makeSUT() -> FormViewController {
        let sut = FormUIComposer.makeView(validateUniqueUsername: { _ in
            .just(.unused)
        })
        
        return sut
    }
}
