//
//  APIError.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/02/15.
//

import Foundation
import Moya

enum APIError: Error {
    case decode
    case response(MoyaError)
}
