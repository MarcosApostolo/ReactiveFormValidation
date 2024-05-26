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
    
    func simulateLongUsernameError() {
        simulateTyping(on: usernameTextFieldController.textField, value: "username with more than thirty two characters")
    }
    
    func simulateNonUniqueUsernameError() {
        simulateTyping(on: usernameTextFieldController.textField, value: "non unique username")
        
        usernameTextFieldController.validateUsernameButton.sendActions(for: .touchUpInside)
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    let traitCollection: UITraitCollection
    
    struct Dimension {
        let width: Int
        let height: Int
    }
    
    enum Device {
        case iPhone15
        case iPhoneSE
        case iPhoneSE1
        case iPhone15ProMax
        
        func getDeviceDimensions() -> Dimension {
            switch self {
            case .iPhone15:
                return Dimension(width: 393, height: 852)
            case .iPhoneSE:
                return Dimension(width: 375, height: 667)
            case .iPhoneSE1:
                return Dimension(width: 320, height: 568)
            case .iPhone15ProMax:
                return Dimension(width: 430, height: 932)
            }
        }
    }
    
    static func iPhone(style: UIUserInterfaceStyle, device: Device = .iPhone15, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        let dimensions = device.getDeviceDimensions()
        
        return SnapshotConfiguration(
            size: CGSize(width: dimensions.width, height: dimensions.height),
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
