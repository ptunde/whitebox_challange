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
    let localDatasource: CryptoLocalDatasource
    
    
    
    // MARK: - init
    init(remoteDatasource: CryptoRemoteDatasource,
         localDatasource: CryptoLocalDatasource) {
        self.remoteDatasource = remoteDatasource
        self.localDatasource = localDatasource
    }
    
    
    
    // MARK: - impl
    func getAssetList() -> AnyPublisher<(list: [CryptoAsset], isOfflineData: Bool), Error> {
        
        Publishers.Zip(remoteDatasource.getAssetList(), localDatasource.getFavoritesAssets())
            .map { (all, favorites) in
                all.map { item in
                    item.copy(isFavorite: favorites.contains(where: { item.id == $0.id }))
                }
            }
            .flatMap { list in
                localDatasource
                    .deleteAssetList()
                    .flatMap { _ in
                        localDatasource
                        .saveAssetList(list: list)
                        .map { _ in (list: list, isOfflineData: false) }
                    }
                    .eraseToAnyPublisher()
            }
            .catch { error in
                switch error as? CustomError {
                case .networkOffline:
                    return localDatasource
                        .getAssetList()
                        .map { (list: $0, isOfflineData: true) }
                        .eraseToAnyPublisher()
                default:
                    return .fail(with: error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    
    func updateAsset(asset: CryptoAsset) -> AnyPublisher<CryptoAsset, Error> {
        localDatasource.updateAsset(asset: asset)
    }
    
    
    
    func getAssetExchangeRate(id: String, inCurrency: CryptoCurrency) -> AnyPublisher<CryptoExchangeRate, Error> {
        remoteDatasource
            .getAssetExchangeRate(id: id, inCurrency: inCurrency)
            .flatMap { localDatasource.saveAssetExchangeRate(rate: $0) }
            .catch { error in
                if let myError = error as? CustomError {
                    switch myError {
                    case .networkOffline: return localDatasource.getAssetExchangeRate(id: id)
                    default: return .fail(with: error)
                    }
                } else {
                    return .fail(with: error)
                }
            }
            .eraseToAnyPublisher()
    }
}
