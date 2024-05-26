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
    override func setUp() {
        super.setUp()
        fileNameOptions = .screenSize
    }
    
    func test_formWithInitialState() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .light)), identifier: "INITIAL_STATE_LIGHT")
        FBSnapshotVerifyView(snapshotConfig(sut, configuration: .iPhone(style: .dark)), identifier: "INITIAL_STATE_DARK")
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
    
    // MARK: Helpers
    func makeSUT() -> FormViewController {
        let sut = FormUIComposer.makeView(validateUniqueUsername: { _ in
            .just(.unused)
        })
        
        return sut
    }
    
    
    func snapshotConfig(_ vc: FormViewController, configuration: SnapshotConfiguration) -> UIView {
        let _ = SnapshotWindow(configuration: configuration, root: vc)
        
        return vc.view
    }
}

private extension FormViewController {
    func simulateNameRequiredError() {
        nameTextFieldController.viewModel.textFieldIsFocused.onNext(true)
        nameTextFieldController.viewModel.textFieldIsFocused.onNext(false)
    }
    
    func simulateEmailRequiredError() {
        emailTextFieldController.viewModel.textFieldIsFocused.onNext(true)
        emailTextFieldController.viewModel.textFieldIsFocused.onNext(false)
    }
    
    func simulateInvalidEmailError() {
        simulateTyping(on: emailTextFieldController.textField, value: "invalid email")
    }
    
    func simulateUsernameRequiredError() {
        usernameTextFieldController.viewModel?.textFieldIsFocused.onNext(true)
        usernameTextFieldController.viewModel?.textFieldIsFocused.onNext(false)
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    let traitCollection: UITraitCollection
    
    static func iPhone(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        return SnapshotConfiguration(
            size: CGSize(width: 390, height: 844),
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = .leftToRight
                traits.preferredContentSizeCategory = contentSize
                traits.userInterfaceIdiom = .phone
                traits.horizontalSizeClass = .compact
                traits.verticalSizeClass = .regular
                traits.displayScale = 3
                traits.accessibilityContrast = .normal
                traits.displayGamut = .P3
                traits.userInterfaceStyle = style
            }))
    }
}

private final class SnapshotWindow: UIWindow {
    private var configuration: SnapshotConfiguration = .iPhone(style: .light)
    
    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.rootViewController = root
        self.isHidden = false
    }
    
    override var traitCollection: UITraitCollection {
        configuration.traitCollection
    }
    
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}
