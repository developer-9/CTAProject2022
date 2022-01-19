//
//  Requestable.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/01/18.
//

import Foundation

protocol Requestable {
    associatedtype ResponseType: Decodable
    var url: URL { get }
}
