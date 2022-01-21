//
//  ListViewModel.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/19.
//

import Foundation

struct ListViewModel {
    
    private let shop: Shop
    
    var logoImageUrl: URL? {
        return shop.logoImage
    }
    
    var shopName: String {
        return shop.name
    }
    
    private var nearestStationName: String {
        return shop.stationName ?? ""
    }
        
    private var genreName: String {
        return shop.genre?.name ?? ""
    }
    
    var shopDetails: String {
        return "\(genreName) / \(nearestStationName)駅"
    }
    
    var budgetName: String {
        return shop.budget.name
    }
    
    init(shop: Shop) {
        self.shop = shop
    }
}
