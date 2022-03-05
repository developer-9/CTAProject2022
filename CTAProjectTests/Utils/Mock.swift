//
//  Mock.swift
//  CTAProjectTests
//
//  Created by Taisei Sakamoto on 2022/02/21.
//

@testable import CTAProject
import Foundation
import RxSwift

enum TestMockData {

    static func fetchShopResponse() -> ShopResponse {
        let results = Results(shop: shops)
        return ShopResponse(results: results)
    }

    static func fetchShops() -> [Shop] {
        return fetchShopResponse().results.shop
    }

    static func fetchSingleShops() -> Single<[Shop]> {
        return Single.just(fetchShops())
    }
}

extension TestMockData {

    static let mockText = "mock text"
    static let url = URL(string: "https://mock.png")
    static let genre = Genre(name: mockText)
    static let budget = Budget(name: mockText)

    static var shops: [Shop] {
        return [
            Shop(id: mockText, name: mockText, logoImage: url, stationName: mockText, genre: genre, budget: budget)
        ]
    }
}
