//
//  ListItem.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI
import NukeUI



// MARK: - view
struct CryptoListItemView: View {
    
    // MARK: - params
    let item: CryptoAsset
    let toggleFavorite: () -> Void
    let onSelect: () -> Void
    
    
    
    // MARK: - constans
    let iconSize = 32.0
    let iconPlaceholderSize = 26.0
    
    
    
    // MARK: - body
    var body: some View {
        
        ZStack(alignment: .trailing) {
            Button(action: onSelect,
                   label: {
                HStack {
                    if let icon = item.icon {
                        LazyImage(url: URL(string: icon)) { state in
                            if state.isLoading {
                                ProgressView()
                            } else if state.error != nil {
                                errorImage
                            } else {
                                state.image
                            }
                        }
                    } else {
                        errorImage
                    }
                    
                    VStack(alignment: .leading) {
                        Text(item.name).font(.headline)
                        Text(item.id).font(.footnote)
                    }
                    .foregroundColor(.gray)
                    .padding(.leading)
                    
                    Spacer()
                }
            })
            .buttonStyle(.borderless)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.leading)
            .padding(.vertical)
            
            FavoriteButton(isFavorite: item.isFavorite,
                           toggleFavorite: toggleFavorite)
        }
        
    }
    
    
    
    // MARK: - helper
    var errorImage: some View {
        Image(systemName: "exclamationmark.triangle")
            .resizable()
            .frame(width: iconPlaceholderSize, height: iconPlaceholderSize)
            .frame(width: iconSize, height: iconSize, alignment: .center)
            .foregroundColor(.red)
    }
}



// MARK: - preview
struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        CryptoListItemView(item: CryptoAsset(id: "eth",
                                             name: "ETH",
                                             icon: "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png",
                                             isFavorite: false),
                           toggleFavorite: {},
                           onSelect: {})
    }
}
