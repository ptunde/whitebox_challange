//
//  Publisher+ErrorMapping.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Foundation
import Combine



extension Publisher {
    
    func mapError() -> AnyPublisher<Output, Error> {
        self.mapError { error in
            if (error as NSError).code == -1009 {
                return CustomError.networkOffline
            }
            
            switch error {
            case is Swift.DecodingError: return CustomError.api(error: .decoding)
            case is Swift.EncodingError: return CustomError.api(error: .encoding)
            default: return error
            }
        }
        .eraseToAnyPublisher()
    }
}
