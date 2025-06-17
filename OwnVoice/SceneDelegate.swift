//
//  SceneDelegate.swift
//  OwnVoice
//
//  Created by me on 2025/06/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create window
        window = UIWindow(windowScene: windowScene)
        
        // 스플래시 스크린을 먼저 표시
        let splashViewController = SplashViewController()
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }
    
    // 스플래시에서 메인 앱으로 전환하는 함수
    func switchToMainApp() {
        guard let window = window else { return }
        
        let mainViewController = TabBarController()
        
        // 부드러운 전환 애니메이션
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = mainViewController
        }, completion: nil)
    }
}
