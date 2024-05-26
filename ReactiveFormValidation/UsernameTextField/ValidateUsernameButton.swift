//
//  ValidateUsernameButton.swift
//  ReactiveFormValidation
//
//  Created by Marcos Amaral on 26/05/24.
//

import UIKit

class ValidateUsernameButton: UIButton {
    private(set) lazy var loadingIndicator: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        
        return loading
    }()
    
    private(set) lazy var image: UIImage? = {
        .init(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        configuration = config
        tintColor = .blue
        setImage(image, for: .normal)
        
        addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    public func startLoading() {
        imageView?.isHidden = true
        
        loadingIndicator.startAnimating()
    }
    
    public func stopLoading() {
        imageView?.isHidden = false
        
        loadingIndicator.stopAnimating()
    }
}
