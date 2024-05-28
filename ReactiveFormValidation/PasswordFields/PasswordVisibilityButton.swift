//
//  PasswordButton.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 28/05/24.
//

import UIKit

class PasswordVisibilityButton: UIButton {
    private lazy var eyeOpenImage: UIImage? = {
        UIImage(systemName: "eye", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
    }()
    
    private lazy var eyeClosedImage: UIImage? = {
        UIImage(systemName: "eye.slash", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        configuration = config
        tintColor = .blue
        setImage(eyeClosedImage, for: .normal)
    }
    
    public func show() {
        setImage(eyeOpenImage, for: .normal)
    }
    
    public func hide() {
        setImage(eyeClosedImage, for: .normal)
    }
}
