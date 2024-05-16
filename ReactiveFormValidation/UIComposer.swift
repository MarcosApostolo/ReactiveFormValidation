//
//  UIComposer.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 15/05/24.
//

import Foundation

class UIComposer {
    static func makeView() -> ViewController {
        let vc = ViewController()
        
        let viewModel = ViewModel()
        
        vc.viewModel = viewModel
        
        return vc
    }
}
