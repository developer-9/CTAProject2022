//
//  UIColor+RGB.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/11.
//

import UIKit

extension UIColor {
    static private func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    enum CTA {
        static let baseGray = UIColor.rgb(red: 153, green: 153, blue: 153)
        static let baseYellow = UIColor.rgb(red: 255, green: 204, blue: 0)
        static let searchBarBackground = UIColor.rgb(red: 255, green: 253, blue: 245)
    }
}
