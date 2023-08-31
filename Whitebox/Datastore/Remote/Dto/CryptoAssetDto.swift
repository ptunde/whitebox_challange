//
//  CryptoAssetDto.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 30..
//

import Combine


    
// MARK: asset
struct CryptoAssetDto: Decodable {
    var id: String
    var name: String
    var assetType: Int
    
    
    
    // MARK: coding keys
    enum CodingKeys: String, CodingKey {
        case id = "asset_id"
        case name
        case assetType = "type_is_crypto"
    }
}



// MARK: - helper
enum AssetTypes: Int {
    case crypto = 1
}
