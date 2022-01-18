//
//  Shop.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/16.
//

import Foundation

// MARK: - ShopResponse

struct ShopResponse: Decodable {
    let results: Results
}

// MARK: - Result

struct Results: Decodable {
    let shop: [Shop]
}

// MARK: - Shop

struct Shop: Decodable {
    let id: String
    let name: String
    let logoImage: URL?
    let stationName: String?
    let genre: Genre?
    let budget: Budget
}

// MARK: - Genre

struct Genre: Decodable {
    let name: String
}

// MARK: - Budget

struct Budget: Decodable {
    let name: String
}
