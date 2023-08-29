//
//  ListItem.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI



// MARK: - view
struct CryptoListItemView: View {
    let item: CryptoAsset
    let toggleFavorite: () -> Void
    let onSelect: () -> Void
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Button {
                onSelect()
            } label: {
                HStack {
                    AsyncImage(url: URL(string: item.icon))
                    
                    Text(item.name).foregroundColor(.gray)
                    
                    Spacer()
                }
            }
            .buttonStyle(.borderless)
            //.buttonStyle(LightGrayButtonSyle())
            
            FavoriteButton(isFavorite: item.isFavorite,
                           toggleFavorite: toggleFavorite)
        }
    }
}



// MARK: - preview
struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        CryptoListItemView(item: CryptoAsset(name: "ETH",
                             icon: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png",
                             isFavorite: false),
                 toggleFavorite: {},
                 onSelect: {})
    }
}
