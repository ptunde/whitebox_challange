//
//  Errors.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Foundation



enum CustomErrors: Error {
    case api(error: APIErrors)
    case storage(StorageError)
    case networkOffline
}

enum APIErrors: Error {
    case assetNotFound
    case decoding
    case encoding
}


enum StorageError: Error {
    case itemNotFound
}