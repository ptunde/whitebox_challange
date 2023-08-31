//
//  CryptoRemoteDatasource.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Combine



protocol CryptoRemoteDatasource {
    func getAssetList() -> AnyPublisher<[CryptoAsset], Error>
    func getAssetExchangeRate(id: String, inCurrency: CryptoCurrency) -> AnyPublisher<CryptoExchangeRate, Error>
}
