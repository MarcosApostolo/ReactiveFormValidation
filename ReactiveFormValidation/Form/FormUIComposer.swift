//
//  UIComposer.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import Foundation
import RxSwift

struct RegisterInfo: Equatable {
    let name: String
    let email: String
    let username: String
    let passsowrd: String
}

protocol RegisterService {
    func onRegister(registerInfo: RegisterInfo, completion: @escaping (Result<Void, Error>) -> Void)
}

class FormUIComposer {
    static func makeView(
        validateUniqueUsername: @escaping (String) -> Single<UsernameStatus>,
        registerService: RegisterService
    ) -> FormViewController {
        let vc = FormViewController()
        
        let registerServiceAdapter: (RegisterInfo) -> Single<Void> = { registerInfo in
            Single<Void>.create(subscribe: { single in
                registerService.onRegister(registerInfo: registerInfo, completion: { result in
                    switch result {
                    case .success:
                        single(.success(()))
                    case let .failure(error):
                        single(.failure(error))
                    }
                })
                
                return Disposables.create()
            })
        }
        
        vc.usernameFormFieldController.viewModel.validateUniqueUsername = validateUniqueUsername
        
        let viewModel = FormViewModel(registerService: registerServiceAdapter)
        
        vc.viewModel = viewModel
        
        return vc
    }
}
