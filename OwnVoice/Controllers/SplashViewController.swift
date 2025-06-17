//
//  SplashViewController.swift
//  OwnVoice
//
//  Created by me on 2025/06/17.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    private let appNameLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startSplashSequence()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 오리지널 로고 이미지
        logoImageView.image = UIImage(named: "logo.png")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.alpha = 0
        view.addSubview(logoImageView)
        
        // 제약 조건 설정
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 로고 이미지
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func startSplashSequence() {
        // 0.5초 후 로고 페이드인
        UIView.animate(withDuration: 0.8, delay: 0.3, options: .curveEaseInOut, animations: {
            self.logoImageView.alpha = 1.0
        })
        
        // 2.5초 후 메인 앱으로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.navigateToMainApp()
        }
    }
    
    private func navigateToMainApp() {
        // SceneDelegate의 전환 함수 호출
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.switchToMainApp()
        }
    }
}
