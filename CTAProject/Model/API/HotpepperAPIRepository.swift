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
protocol HotpepperAPIRepositoryType {
    func searchRequest(keyword: String) -> Single<ShopResponse>
}


final class HotpepperAPIRepository: HotpepperAPIRepositoryType {

    // MARK: - Properties

    private let searchProvider = MoyaProvider<HotPepperAPIService.SearchShopsRequest>()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    // MARK: - Functions

    func searchRequest(keyword: String) -> Single<ShopResponse> {
        return Single<ShopResponse>.create { [self, searchProvider] result in
            searchProvider.request(.init(keyword: keyword)) { [decoder] moyaResult in
                switch moyaResult {
                case .success(let response):
                    do {
                        let shopResponse = try decoder.decode(ShopResponse.self, from: response.data)
                        result(.success(shopResponse))
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
