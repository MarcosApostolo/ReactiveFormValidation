//
//  EmailValidation.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 01/06/24.
//

import Foundation

func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
