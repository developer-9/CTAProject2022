//
//  MainTabBarController.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/11.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    // MARK: - Helpers
    
    private func configureViewControllers() {
        tabBar.tintColor = .baseYellow
        
        let searchVC = templeteNavigationController(title: "リスト", systemName: "list.bullet", rootViewController: ListViewController())
        let favoriteVC = templeteNavigationController(title: "お気に入り", systemName: "star", rootViewController: FavoriteViewController())
        
        viewControllers = [searchVC, favoriteVC]
    }
    
    private func templeteNavigationController(title: String, systemName: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = UIImage(systemName: systemName)
        return nav
    }
}
