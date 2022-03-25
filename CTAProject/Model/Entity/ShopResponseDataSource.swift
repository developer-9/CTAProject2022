//
//  ShopResponseDataSource.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/31.
//

import Foundation
import RxDataSources

struct ShopResponseDataSource {
    var items: [Item]
}

extension ShopResponseDataSource: SectionModelType {
    typealias Item = Shop

    init(original: ShopResponseDataSource, items: [Shop]) {
        self = original
        self.items = items
    }
}
