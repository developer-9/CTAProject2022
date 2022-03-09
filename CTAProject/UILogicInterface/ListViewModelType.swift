//
//  ListViewModelType.swift
//  CTAProject
//
//  Created by Taisei Sakamoto on 2022/03/09.
//

import Foundation
import Unio

protocol ListViewStreamType: AnyObject {
    var input: InputWrapper<ListViewStream.Input> { get }
    var output: OutputWrapper<ListViewStream.Output> { get }
}
