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
                return CustomErrors.networkOffline
            }
            
            switch error {
            case is Swift.DecodingError: return CustomErrors.api(error: .decoding)
            case is Swift.EncodingError: return CustomErrors.api(error: .encoding)
            default: return error
            }
        }
        .eraseToAnyPublisher()
    }
}
