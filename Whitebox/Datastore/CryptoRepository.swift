//
//  CryptoRepository.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 29..
//

import Combine



// MARK: - protocol
protocol CryptoRepository {
    func getAssetList() -> AnyPublisher<(list: [CryptoAsset], isOfflineData: Bool), Error>
    func getAssetExchangeRate(id: String, inCurrency: CryptoCurrency) -> AnyPublisher<CryptoExchangeRate, Error>
    func updateAsset(asset: CryptoAsset) -> AnyPublisher<CryptoAsset, Error>
}
