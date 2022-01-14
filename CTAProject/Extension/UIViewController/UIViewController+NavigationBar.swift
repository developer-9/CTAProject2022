//
//  UIViewController+NavigationBar.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/12.
//

import UIKit

extension UIViewController {
    
    func configureNavigationBar(withTitle title: String) {
        
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor : UIColor.white,
            .font : UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
        navigationBarAppearance.backgroundColor = UIColor.CTA.baseYellow
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = title
    }
}
