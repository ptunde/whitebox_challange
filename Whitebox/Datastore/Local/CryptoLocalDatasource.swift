//
//  CryptoLocalDatasource.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Combine



protocol CryptoLocalDatasource {
    // get
    func getAssetList() -> AnyPublisher<[CryptoAsset], Error>
    func getAssetExchangeRate(id: String) -> AnyPublisher<CryptoExchangeRate, Error>
    func getFavoritesAssets() -> AnyPublisher<[CryptoAsset], Error>
        
    // delete
    func deleteAssetList() -> AnyPublisher<Bool, Error>

    // save
    func saveAssetList(list: [CryptoAsset]) -> AnyPublisher<[CryptoAsset], Error>
    func saveAssetExchangeRate(rate: CryptoExchangeRate) -> AnyPublisher<CryptoExchangeRate, Error>
    
    // update
    func updateAsset(asset: CryptoAsset) -> AnyPublisher<CryptoAsset, Error>
}
