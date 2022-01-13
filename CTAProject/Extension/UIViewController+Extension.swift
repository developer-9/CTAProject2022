//
//  UIViewController+Extension.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/12.
//

import UIKit

extension UIViewController {
    
    public func configureNavigationBar(withTitle title: String) {
        
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor : UIColor.white,
            .font : UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
        navigationBarAppearance.backgroundColor = .baseYellow
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = title
    }
}
