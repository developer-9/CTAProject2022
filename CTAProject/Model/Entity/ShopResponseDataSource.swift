//
//  ShopResponseDataSource.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/31.
//

import Foundation
import RxDataSources

struct ShopResponseSectionModel {
    var items: [Item]
}

extension ShopResponseSectionModel: SectionModelType {
    typealias Item = Shop

    init(original: ShopResponseSectionModel, items: [Shop]) {
        self = original
        self.items = items
    }
}
