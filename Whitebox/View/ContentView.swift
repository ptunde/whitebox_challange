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
    
    
    
    // MARK: - body
    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
            
        case .loaded(let items):
            CryptoListView(items: items)
            
        case .error(let error):
            Text(error)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
