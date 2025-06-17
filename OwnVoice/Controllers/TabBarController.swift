//
//  TabBarController.swift
//  OwnVoice
//
//  Created by me on 2025/06/13.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recordVC = RecordViewController()
        recordVC.tabBarItem = UITabBarItem(title: "Record", image: UIImage(systemName: "mic"), tag: 0)
        
        let diaryVC = DiaryViewController()
        diaryVC.tabBarItem = UITabBarItem(title: "Diary", image: UIImage(systemName: "book"), tag: 1)
        
        let pronunciationVC = PronunciationViewController()
        pronunciationVC.tabBarItem = UITabBarItem(title: "Pronunciation", image: UIImage(systemName: "speaker.wave.2"), tag: 2)
        
        let tipVC = TipViewController()
        tipVC.tabBarItem = UITabBarItem(title: "Tip", image: UIImage(systemName: "lightbulb"), tag: 3)
        
        
        self.viewControllers = [recordVC, diaryVC, pronunciationVC, tipVC].map {
            UINavigationController(rootViewController: $0)
        }
        
        tabBar.tintColor = .white
        tabBar.barTintColor = UIColor(hex: "4A2511")
        tabBar.isTranslucent = false
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hex: "4A2511")
            
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
            itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.stackedLayoutAppearance = itemAppearance
            
            tabBar.standardAppearance = appearance

        } else {
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        }
    }
}
