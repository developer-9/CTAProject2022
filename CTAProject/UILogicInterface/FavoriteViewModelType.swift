//
//  FavoriteViewModelType.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/03/19.
//

import Foundation
import Unio

protocol FavoriteViewStreamType: AnyObject {
    var input: InputWrapper<FavoriteViewStream.Input> { get }
    var output: OutputWrapper<FavoriteViewStream.Output> { get }
}
