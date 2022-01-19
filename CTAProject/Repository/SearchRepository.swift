//
//  SearchRepository.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/18.
//

import Foundation

protocol SearchRepository {
    var client: APIClient { get }
    func searchShops(with keyword: String, completion: @escaping(Result<ShopResponse, APIError>) -> Void)
}

final class SearchRepositoryImpl: SearchRepository {
    
    let client: APIClient
    
    init(client: APIClient = APIClient()) {
        self.client = client
    }
    
    func searchShops(with keyword: String, completion: @escaping (Result<ShopResponse, APIError>) -> Void) {
        let request = SearchAPIRequest(keyword: keyword)
        return client.request(request, completion: completion)
    }
}
