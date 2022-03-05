//
//  APIClient.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/16.
//

import Foundation
import Moya
import RxSwift

/// @mockable
protocol HotpepperRepositoryType {
    func searchRequest(keyword: String) -> Single<[Shop]>
}


final class HotpepperRepository: HotpepperRepositoryType {

    // MARK: - Properties

    private let searchProvider = MoyaProvider<HotPepperAPIService.SearchShopsRequest>()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    // MARK: - Functions
    
    func searchRequest(keyword: String) -> Single<[Shop]> {
        return Single<[Shop]>.create { [self, searchProvider] result in
            searchProvider.request(.init(keyword: keyword)) { [decoder] moyaResult in
                switch moyaResult {
                case .success(let response):
                    do {
                        let shopResponse = try decoder.decode(ShopResponse.self, from: response.data)
                        let shops = shopResponse.results.shop
                        result(.success(shops))
                    } catch {
                        result(.failure(APIError.decode))
                    }
                case .failure(let moyaError):
                    result(.failure(APIError.response(moyaError)))
                }
            }
            return Disposables.create()
        }
    }
}
