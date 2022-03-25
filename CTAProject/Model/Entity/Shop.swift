//
//  Shop.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/16.
//

import Foundation

// MARK: - ShopResponse

struct ShopResponse: Decodable, Equatable {
    let results: Results
}

// MARK: - Result

struct Results: Decodable, Equatable {
    let shop: [Shop]
}

// MARK: - Shop

struct Shop: Decodable, Equatable {

    let id: String
    let name: String
    let logoImage: URL
    let stationName: String?
    let genre: Genre?
    let budget: Budget
}

// MARK: - Genre

struct Genre: Decodable, Equatable {
    let name: String
}

// MARK: - Budget

struct Budget: Decodable, Equatable {
    let name: String
}
