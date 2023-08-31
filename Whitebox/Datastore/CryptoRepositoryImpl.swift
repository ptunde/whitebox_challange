//
//  CryptoRepositoryImpl.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 29..
//

import Foundation
import Combine



// MARK: - struct
struct CryptoRepositoryImpl: CryptoRepository {
    
    // MARK: - props
    let remoteDatasource: CryptoRemoteDatasource
    
    
    
    // MARK: - init
    init(remoteDatasource: CryptoRemoteDatasource) {
        self.remoteDatasource = remoteDatasource
    }
    
    
    
    // MARK: - impl
    func getAssetList() -> AnyPublisher<[CryptoAsset], Error> {
        remoteDatasource
            .getAssetList()
            .catch { error in
                switch error as? CustomErrors {
                case .networkOffline: print("TODO: local ds data load")
                default: break
                }
                return Fail(outputType: [CryptoAsset].self, failure: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    
    
    func getAssetExchangeRate(id: String, inCurrency: CryptoCurrency) -> AnyPublisher<CryptoExchangeRate, Error> {
        remoteDatasource
            .getAssetExchangeRate(id: id, inCurrency: inCurrency)
    }
}
