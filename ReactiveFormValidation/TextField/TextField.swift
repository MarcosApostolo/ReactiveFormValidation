//
//  TextField.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 29/05/24.
//

import UIKit

class TextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let focusedBorderWidth: CGFloat = 1
    private let unfocusedBorderWidth: CGFloat = 0.25
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 8)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func setup() {
        layer.cornerRadius = 5
        layer.borderWidth = unfocusedBorderWidth
        layer.borderColor = UIColor.lightGray.cgColor
        
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    public func applyValidStyle() {
        layer.borderColor = UIColor.blue.cgColor
    }
    
    public func applyErrorStyle() {
        layer.borderColor = UIColor.red.cgColor
    }
    
    public func applyFocusedStyle() {
        layer.borderWidth = focusedBorderWidth
    }
    
    public func applyUnfocusedStyle() {
        layer.borderWidth = unfocusedBorderWidth
    }
}
