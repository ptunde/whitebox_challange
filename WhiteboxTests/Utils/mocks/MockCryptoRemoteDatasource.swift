//
//  MockCryptoRemoteDatasource.swift
//  WhiteboxTests
//
//  Created by Tünde Péter on 2023. 09. 01..
//

import Foundation
import Combine
@testable import Whitebox



class MockCryptoRemoteDatasource: CryptoRemoteDatasource {
    var getListResult: Deferred<Future<[CryptoAsset], Error>>!
    var getListCalls: Int = 0
    
    var getRateResult: Deferred<Future<CryptoExchangeRate, Error>>!
    var getRateCalls = [String]()
    
    
    
    func getAssetList() -> AnyPublisher<[CryptoAsset], Error> {
        getListCalls += 1
        return getListResult.eraseToAnyPublisher()
    }
    
    
    
    func getAssetExchangeRate(id: String, inCurrency: CryptoCurrency) -> AnyPublisher<CryptoExchangeRate, Error> {
        getRateCalls.append(id)
        return getRateResult.eraseToAnyPublisher()
    }
}
