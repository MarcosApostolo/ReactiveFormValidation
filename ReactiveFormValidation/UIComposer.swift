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
        
        let usernameViewModel = UsernameTextFieldViewModel(validateUniqueUsername: validateUniqueUsername)
                
        vc.usernameTextFieldController.viewModel = usernameViewModel
        
        let viewModel = ViewModel()
        
        vc.viewModel = viewModel
        
        return vc
    }
}
