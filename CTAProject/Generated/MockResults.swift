///
/// @Generated by Mockolo
///



import Foundation
import Moya
import PKHUD
import RxCocoa
import RxSwift
import Unio


class HotpepperRepositoryTypeMock: HotpepperRepositoryType {
    init() { }


    private(set) var searchRequestCallCount = 0
    var searchRequestHandler: ((String) -> (Single<[Shop]>))?
    func searchRequest(keyword: String) -> Single<[Shop]> {
        searchRequestCallCount += 1
        if let searchRequestHandler = searchRequestHandler {
            return searchRequestHandler(keyword)
        }
        fatalError("searchRequestHandler returns can't have a default value thus its handler must be set")
    }
}

