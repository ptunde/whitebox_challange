//
//  CryptoDetailView.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI



// MARK: - view
struct CryptoDetailView: View {
    
    // MARK: - properties
    @StateObject var viewModel: CryptoDetailViewModel
    
    
    
    // MARK: - body
    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
            
        case .loaded(let asset):
            CryptoDetailContentView(asset: asset)
            .navigationTitle(asset.name)
            
        case .error:
            Text("Failed to load data")
        }
    }
    
    
    
    // MARK: - init
    init(asset: CryptoAsset) {
        _viewModel = StateObject(wrappedValue: CryptoDetailViewModel(asset: asset))
    }
}
