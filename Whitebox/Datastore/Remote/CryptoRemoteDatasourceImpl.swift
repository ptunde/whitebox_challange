//
//  CryptoRemoteDatasourceImpl.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Foundation
import Combine



struct CryptoRemoteDatasourceImpl: CryptoRemoteDatasource {
    
    // MARK: - props
    let configuration: CryptoRemoteDatasourceConfiguration
    let session: URLSession
    
    
    
    // MARK: - init
    init(configuration: CryptoRemoteDatasourceConfiguration,
         session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }
    
    
    
    // MARK: - impl
    func getAssetList() -> AnyPublisher<[CryptoAsset], Error> {
        Publishers.Zip(getList(), getIcons())
            .tryMap { (list, icons) in
                list.map { item in
                    let icon = icons.first { item.id == $0.id }
                    return CryptoAsset(id: item.id, name: item.name, icon: icon?.url, isFavorite: false)
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    
    func getAssetExchangeRate(id: String, inCurrency: CryptoCurrency) -> AnyPublisher<CryptoExchangeRate, Error> {
        session
            .dataTaskPublisher(for: builRequest(httpMethod: .get,
                                                for: "/exchangerate/\(id)/\(inCurrency.rawValue)"))
            .map { $0.data }
            .decode(type: CryptoExchangeRateDto.self, decoder: JSONDecoder())
            .tryMap { CryptoExchangeRate(id: $0.id, rate: $0.rate) }
            .eraseToAnyPublisher()
    }
    
    
    
    // MARK: - helper
    private func getList() -> AnyPublisher<[CryptoAssetDto], Error> {
        session
            .dataTaskPublisher(for: builRequest(httpMethod: .get,
                                                for: "/assets"))
            .validateResponse()
            .decode(type: [CryptoAssetDto].self, decoder: JSONDecoder())
            .map { $0.filter { $0.assetType == AssetTypes.crypto.rawValue } }
            .mapError()
    }
    
    
    
    private func getIcons() -> AnyPublisher<[CryptoAssetIconDto], Error> {
        session
            .dataTaskPublisher(for: builRequest(httpMethod: .get,
                                                for: "/assets/icons/32"))
            .validateResponse()
            .decode(type: [CryptoAssetIconDto].self, decoder: JSONDecoder())
            .mapError()
    }
    
    
    private func builRequest(httpMethod: HTTPMethod, for path: String) -> URLRequest {
        let url = URL(string: configuration.baseUrl)!.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = ["\(configuration.headerAPIKey)": "\(configuration.apiKey)"]
        return request
    }
}
