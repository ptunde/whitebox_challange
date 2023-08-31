//
//  CryptoDetailContentView.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import SwiftUI



struct CryptoDetailContentView: View {
    let asset: CryptoDetailVO
    
    
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ShapedText(title: asset.detail)
            
            ShapedText(title: asset.rate)
            
            Spacer()
        }
    }
}





// MARK: - preview
struct CryptoDetailContentView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoDetailContentView(asset: CryptoDetailVO(name: "BTC",
                                                      detail: "Details of: BTC",
                                                      rate: "Exchange rate: 25.000 eur"))
    }
}
