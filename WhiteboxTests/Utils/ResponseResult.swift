//
//  ResponseResult.swift
//  WhiteboxTests
//
//  Created by Tünde Péter on 2023. 09. 01..
//

import Foundation



enum ResponseResult<T> {
    case success(T)
    case failure(Error)
}
