//
//  UITableView+Register.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/14.
//

import Foundation
import UIKit

extension UITableView {

    func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("DEBUG: \(cellType.self)のキャストに失敗しました。")
        }
        return cell
    }
}
