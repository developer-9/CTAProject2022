//
//  SearchAPIRequest.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/18.
//

import Foundation

enum HotPapperApiVersion: String {
    case v1 = "/hotpepper/gourmet/v1/"
}

struct SearchAPIRequest: Requestable {
    typealias ResponseType = ShopResponse
    
    let keyword: String
    
    var url: URL {
        var baseUrl = URLComponents(string: "https://webservice.recruit.co.jp")!
        baseUrl.path = HotPapperApiVersion.v1.rawValue
        baseUrl.queryItems = [
            URLQueryItem(name: "key", value: Key.hotPapperApi),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "count", value: "30"),
            URLQueryItem(name: "keyword", value: keyword)
        ]
        return baseUrl.url!
    }
}
