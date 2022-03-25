//
//  FavoriteShop.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/03/12.
//

import Foundation
import RealmSwift

final class FavoriteShop: Object {
    @Persisted var name : String
    @Persisted var budget: String
    @Persisted var genre: String
    @Persisted var station: String
    @Persisted var logoImage: String

    @Persisted(primaryKey: true) var id: String

    convenience init(shop: Shop) {
        self.init()
        self.id = shop.id
        self.name = shop.name
        self.budget = shop.budget.name
        self.genre = shop.genre?.name ?? ""
        self.station = shop.stationName ?? ""
        self.logoImage = "\(shop.logoImage)"
    }
}
