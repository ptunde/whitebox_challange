//
//  CryptoDetailView.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI



// MARK: - view
struct CryptoDetailView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ShapedText(title: "Detail of asset")
            
            ShapedText(title: "Exchange rate")
            
            Spacer()
        }
        .navigationTitle("Crypto Detail")
    }
}


// MARK: - preview
struct CryptoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoDetailView()
    }
}
