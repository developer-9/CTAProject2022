//
//  NSObjectProtocol+ReuseIdentifier.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/14.
//

import Foundation

extension NSObjectProtocol {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
