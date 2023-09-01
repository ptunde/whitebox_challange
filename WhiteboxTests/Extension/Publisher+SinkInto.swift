//
//  Publisher+SinkInto.swift
//  WhiteboxTests
//
//  Created by Tünde Péter on 2023. 09. 01..
//

import Combine



extension Publisher {
    
    func sinkInto(callback: @escaping (Output?, Error?) -> Void) -> AnyCancellable {
        
        self.sink { completion in
            if case .failure(let error) = completion {
                callback(nil, error)
            }
        } receiveValue: { value in
            callback(value, nil)
        }
    }
}
