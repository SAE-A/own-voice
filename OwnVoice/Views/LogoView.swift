//
//  LogoView.swift
//  OwnVoice
//
//  Created by me on 2025/06/13.
//

import Foundation
import UIKit

class LogoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLogo()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLogo()
    }
    
    private func setupLogo() {
        let logoImageView = UIImageView(image: UIImage(named: "logo2"))
        logoImageView.contentMode = .scaleAspectFit
        addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
