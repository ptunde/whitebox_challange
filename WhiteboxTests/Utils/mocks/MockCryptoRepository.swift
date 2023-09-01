//
//  MockCryptoRepository.swift
//  WhiteboxTests
//
//  Created by Tünde Péter on 2023. 09. 01..
//

@testable import Whitebox
import Foundation
import Combine



class MockCryptoRepository: CryptoRepository {
    var getRateResult: Deferred<Future<CryptoExchangeRate, Error>>!
    var getRateCalls = [String]()
    
    
    
    // MARK: - impl
    func getAssetList() -> AnyPublisher<(list: [CryptoAsset], isOfflineData: Bool), Error> {
        Empty().eraseToAnyPublisher() // TODO
    }
    
    
    
    func getAssetExchangeRate(id: String, inCurrency: CryptoCurrency) -> AnyPublisher<Whitebox.CryptoExchangeRate, Error> {
        getRateCalls.append(id)
        return getRateResult.eraseToAnyPublisher()
    }
    
    
    
    func updateAsset(asset: CryptoAsset) -> AnyPublisher<CryptoAsset, Error> {
        Empty().eraseToAnyPublisher() // TODO
    }
}
