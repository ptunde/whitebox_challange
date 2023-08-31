//
//  CryptoAsset.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import Foundation



struct CryptoAsset: Identifiable {
    let id: String
    let name: String
    let icon: String?
    var isFavorite: Bool
    
    
    func copy() -> CryptoAsset {
        CryptoAsset(id: self.id, name: self.name, icon: self.icon, isFavorite: self.isFavorite)
    }
}
