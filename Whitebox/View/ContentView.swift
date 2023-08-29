//
//  ContentView.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI
import CoreData



struct ContentView: View {

    private var items: [CryptoAsset] = [CryptoAsset(name: "BTC",
                                                    icon: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/204e55dd8dab4a0d823c21f04be6be4b.png",
                                                    isFavorite: true),
                                        CryptoAsset(name: "ETH",
                                                    icon: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png",
                                                    isFavorite: false)]
        
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
            .navigate(when: $selectedItem) { _ in CryptoDetailView() }
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
