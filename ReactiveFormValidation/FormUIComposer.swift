//
//  UIComposer.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import Foundation
import RxSwift

class FormUIComposer {
    static func makeView(validateUniqueUsername: @escaping (String) -> Single<UsernameStatus>) -> FormViewController {
        let vc = FormViewController()
        
        let usernameViewModel = UsernameFormFieldViewModel(validateUniqueUsername: validateUniqueUsername)
                
        vc.usernameFormFieldController.viewModel = usernameViewModel
        
        let viewModel = FormViewModel()
        
        vc.viewModel = viewModel
        
        return vc
    }
}
