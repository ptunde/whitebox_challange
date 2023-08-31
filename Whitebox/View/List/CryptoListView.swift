//
//  CryptoListView.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import SwiftUI



struct CryptoListView: View {
    
    let items: [CryptoAsset]
    
    @State private var isFavoritesOn = false
    @State private var searchText = ""
    @State private var selectedItem: CryptoAsset?
    
    
    
    // MARK: - body
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    CryptoListItemView(item: item,
                             toggleFavorite: {},
                             onSelect: { selectedItem = item })
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText, prompt: "Search by asset id's")
            .navigationTitle("Crypto list")
            .toolbar {
                ToolbarItem {
                    FavoriteButton(isFavorite: isFavoritesOn,
                                   toggleFavorite: { isFavoritesOn = !isFavoritesOn })
                }
            }
            .navigate(when: $selectedItem) { CryptoDetailView(asset: $0) }
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
        CryptoListView(items: items)
    }
}
