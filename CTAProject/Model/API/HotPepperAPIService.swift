//
//  HotPepperAPIService.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/28.
//

import Foundation
import Moya

final class HotPepperAPIService {}

extension HotPepperAPIService {

    // MARK: - SearchShopsRequest

    struct SearchShopsRequest: APITargetType {

        typealias Response = ShopResponse

        var baseURL: URL {
            return URL(string: "https://webservice.recruit.co.jp")!
        }

        var path: String {
            return "hotpepper/gourmet/v1/"
        }

        var method: Moya.Method {
            return .get
        }

        var sampleData: Data {
            return Data()
        }

        var task: Task {
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }

        var parameters: [String: Any] {
            return [
                "key": Key.hotPepperApi,
                "count": 30,
                "format": "json",
                "keyword": keyword
            ]
        }

        var headers: [String: String]? {
            return ["Content-Type": "application/json"]
        }

        let keyword: String

        init(keyword: String) {
            self.keyword = keyword
        }
    }
}
