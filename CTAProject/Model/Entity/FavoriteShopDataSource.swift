//
//  FavoriteShopDataSource.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/03/12.
//

import Foundation
import RxDataSources

struct FavoriteShopDataSource {
    var items: [Item]
}

extension FavoriteShopDataSource: SectionModelType {
    typealias Item = FavoriteShop

    init(original: FavoriteShopDataSource, items: [FavoriteShop]) {
        self = original
        self.items = items
    }
}
