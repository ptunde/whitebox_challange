//
//  MockCryptoLocalDatasource.swift
//  WhiteboxTests
//
//  Created by Tünde Péter on 2023. 09. 01..
//

import Foundation
import Combine
@testable import Whitebox



class MockCryptoLocalDatasource: CryptoLocalDatasource {
    var getRateResult: Deferred<Future<CryptoExchangeRate, Error>>!
    var getRateCalls = [String]()
    
    
    var saveRateResult: Deferred<Future<CryptoExchangeRate, Error>>!
    var saveRateCalls = [String]()
    
    
    
    func getAssetList() -> AnyPublisher<[CryptoAsset], Error> {
        Empty().eraseToAnyPublisher() // TODO
    }
    
    func getAssetExchangeRate(id: String) -> AnyPublisher<CryptoExchangeRate, Error> {
        getRateCalls.append(id)
        return getRateResult.eraseToAnyPublisher()
    }
    
    func getFavoritesAssets() -> AnyPublisher<[Whitebox.CryptoAsset], Error> {
        Empty().eraseToAnyPublisher() // TODO
    }
    
    func deleteAssetList() -> AnyPublisher<Bool, Error> {
        Empty().eraseToAnyPublisher() // TODO
    }
    
    func saveAssetList(list: [Whitebox.CryptoAsset]) -> AnyPublisher<[Whitebox.CryptoAsset], Error> {
        Empty().eraseToAnyPublisher() // TODO
    }
    
    func saveAssetExchangeRate(rate: Whitebox.CryptoExchangeRate) -> AnyPublisher<Whitebox.CryptoExchangeRate, Error> {
        saveRateCalls.append(rate.id)
        return saveRateResult.eraseToAnyPublisher()
    }
    
    func updateAsset(asset: Whitebox.CryptoAsset) -> AnyPublisher<Whitebox.CryptoAsset, Error> {
        Empty().eraseToAnyPublisher() // TODO
    }
}
