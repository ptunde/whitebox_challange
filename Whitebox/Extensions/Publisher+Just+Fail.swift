//
//  Publisher+Just+Fail.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Combine



extension AnyPublisher {
    static func just(_ output: Output) -> Self {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    
    
    
    static func fail(with error: Failure) -> Self {
        Fail(error: error)
            .eraseToAnyPublisher()
    }
}
