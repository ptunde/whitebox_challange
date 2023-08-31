//
//  CryptoExchangeRateDto.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 30..
//

import Foundation



// MARK: asset
struct CryptoExchangeRateDto: Decodable {
    var id: String
    var time: String
    var rate: Double
    
    
    
    // MARK: keys
    enum CodingKeys: String, CodingKey {
        case id = "asset_id_base"
        case time
        case rate
    }
}
