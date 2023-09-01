//
//  Errors.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Foundation



enum CustomError: Error {
    case api(error: APIError)
    case storage(StorageError)
    case networkOffline
}

enum APIError: Error {
    case assetNotFound
    case decoding
    case encoding
}


enum StorageError: Error {
    case itemNotFound
}
