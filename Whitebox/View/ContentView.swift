//
//  ContentView.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI



struct ContentView: View {

    // MARK: - state
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var selectedItem: CryptoAsset?
    
    
    
    // MARK: - body
    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
            
        case .loaded(let items, let isOfflineData):
            NavigationView {
                VStack(spacing: 0.0) {
                    if isOfflineData {
                        Text("Internet connection is down, displaying offline data.")
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    CryptoListView(items: items,
                                   onTapIsFavorite: viewModel.onTapIsFavorite(asset:),
                                   didSelectItem: { selectedItem = $0 } )
                    .listStyle(.insetGrouped)
                    .searchable(text: $viewModel.searchQuerry, prompt: "Search by asset id's")
                    
                }
                .navigationTitle("Crypto list")
                .toolbar {
                    ToolbarItem {
                        FavoriteButton(isFavorite: viewModel.isDisplayingOnlyFavorites,
                                       toggleFavorite: viewModel.onTapToggleFavorites)
                    }
                }
                .navigate(when: $selectedItem) { CryptoDetailView(asset: $0) }
            }
            
        case .error(let error):
            CustomErrorView(message: error,
                            onRetry: viewModel.reloadData)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
