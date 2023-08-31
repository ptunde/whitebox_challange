//
//  Entity+Mapping.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import CoreData



extension CryptoAssetEntity {
    func mapFromDomain(item: CryptoAsset) {
        self.id = item.id
        self.name = item.name
        self.icon = item.icon
        self.isFavorite = item.isFavorite
    }
}


extension CryptoExchangeRateEntity {
    func mapFromDomain(item: CryptoExchangeRate) {
        self.id = item.id
        self.rate = item.rate
    }
}
