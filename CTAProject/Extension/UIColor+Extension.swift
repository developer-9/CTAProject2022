//
//  UIColor+Extension.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/11.
//

import UIKit

extension UIColor {
    static private func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let baseWhite = UIColor.rgb(red: 0, green: 0, blue: 0)
    static let baseGray = UIColor.rgb(red: 153, green: 153, blue: 153)
    static let baseYellow = UIColor.rgb(red: 255, green: 204, blue: 0)
    static let searchBackViewColor = UIColor.rgb(red: 255, green: 253, blue: 245)
    static let tableViewBackgroundColor = UIColor.rgb(red: 242, green: 242, blue: 247)
}
