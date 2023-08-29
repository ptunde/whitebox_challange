//
//  FavoriteButton.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI



// MARK: - view
struct FavoriteButton: View {
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    
    
    // MARK: - body
    var body: some View {
        Button(action: toggleFavorite) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .padding()
                .foregroundColor(isFavorite ? .red : .gray)
        }
        .buttonStyle(.borderless)
    }
}



// MARK: - preview
struct FavoriteButton_Previews: PreviewProvider {
    // MARK: - helper to test state
    struct Container: View {
        @State var isActive = false
        
        var body: some View {
          FavoriteButton(isFavorite: isActive,
                         toggleFavorite: { isActive = !isActive })
        }
    }
    
    // MARK: - actual preview
    static var previews: some View {
        Container()
    }
}
