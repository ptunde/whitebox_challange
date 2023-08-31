//
//  CryptoRemoteDatasourceConfiguration.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Foundation



// MARK: - remote datasource configurations
struct CryptoRemoteDatasourceConfiguration {
    let baseUrl = "https://rest.coinapi.io/v1"
    let apiKey = "F7EB91FF-71B0-4336-989A-70870EFFDD7D" // api keys normally should be stored at secure location
    let headerAPIKey = "X-CoinAPI-Key"
     
    //let tunde3  = "1267A8FF-38E4-46B6-B10C-EAEBF8E6458F"
    //let tunde2 = "9A52912A-724F-493D-90A4-8E7066C15B2E"
    //let tunde1 = "F7EB91FF-71B0-4336-989A-70870EFFDD7D"
}
