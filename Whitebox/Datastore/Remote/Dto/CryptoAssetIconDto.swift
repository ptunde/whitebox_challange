//
//  CryptoAssetIcon.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 30..
//

import Foundation



// MARK: asset
struct CryptoAssetIconDto: Decodable {
    var id: String
    var url: String
    
    
    
    // MARK: keys
    enum CodingKeys: String, CodingKey {
        case id = "asset_id"
        case url
    }
}
