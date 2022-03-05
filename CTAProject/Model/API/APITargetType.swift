//
//  APITargetType.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/18.
//

import Moya

protocol APITargetType: TargetType {
    associatedtype Response: Decodable
}
