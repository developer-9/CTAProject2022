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
        tabBar.tintColor = UIColor.CTA.baseYellow
        tabBar.backgroundColor = .systemGray6

        let listVC = templeteNavigationController(title: L10n.listTabBarTitle, systemName: "list.bullet",
                                                  rootViewController: ListViewController())
        let favoriteVC = templeteNavigationController(title: L10n.favoriteTabBarTitle, systemName: "star",
                                                      rootViewController: FavoriteViewController())

        viewControllers = [listVC, favoriteVC]
    }

    private func templeteNavigationController(title: String, systemName: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = UIImage(systemName: systemName)
        return nav
    }
}
