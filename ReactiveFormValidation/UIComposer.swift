//
//  UIComposer.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import Foundation
import RxSwift

class UIComposer {
    static func makeView(validateUniqueUsername: @escaping (String) -> Single<UsernameStatus>) -> ViewController {
        let vc = ViewController()
        
        vc.usernameTextFieldController.validateUniqueUsername = validateUniqueUsername
        
        let viewModel = ViewModel()
        
        vc.viewModel = viewModel
        
        return vc
    }
}
