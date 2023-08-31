//
//  CryptoListView.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import SwiftUI



struct CryptoListView: View {
    
    let items: [CryptoAsset]
    let onTapIsFavorite: (CryptoAsset) -> Void
    let didSelectItem: (CryptoAsset) -> Void
    
    
    
    // MARK: - body
    var body: some View {
        List {
            ForEach(items) { item in
                CryptoListItemView(item: item,
                                   toggleFavorite: { onTapIsFavorite(item) },
                                   onSelect: { didSelectItem(item) })
            }
        }
    }
}



struct CryptoListView_Previews: PreviewProvider {
    private static var items = [CryptoAsset(id: "BTC",
                                            name: "BTC",
                                            icon: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/204e55dd8dab4a0d823c21f04be6be4b.png",
                                            isFavorite: true),
                                CryptoAsset(id: "ETH",
                                            name: "ETH",
                                            icon: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png",
                                            isFavorite: false)]
    
    static var previews: some View {
        CryptoListView(items: items,
                       onTapIsFavorite: { _ in },
                       didSelectItem: { _ in })
    }
}
