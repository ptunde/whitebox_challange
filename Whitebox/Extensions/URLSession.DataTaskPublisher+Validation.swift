//
//  URLSession.DataTaskPublisher+Validation.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Foundation
import Combine



extension URLSession.DataTaskPublisher {

    func validateResponse() -> Publishers.TryMap<URLSession.DataTaskPublisher, Data> {
        self.tryMap { element -> Data in
            guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
    }
}
