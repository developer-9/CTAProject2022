//
//  APIError.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/16.
//

enum APIError: Error {
    case server(Int)
    case decode(Error)
    case noResponse
    case unknown(Error)
    
    var description: String {
        switch self {
        case .server(let statusCode):
            return "サーバーエラーが発生しました エラーコード: \(statusCode)"
        case .decode(let error):
            return "デコードに失敗しました エラーコード: \(error.localizedDescription)"
        case .noResponse:
            return "レスポンスがありません"
        case .unknown(let error):
            return "予期せぬエラーが発生しました エラーコード: \(error.localizedDescription)"
        }
    }
}
