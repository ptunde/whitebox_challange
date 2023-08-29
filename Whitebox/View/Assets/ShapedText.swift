//
//  ShapedText.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI



// MARK: - view
struct ShapedText: View {
    let title: String
    var customSize: CGSize = CGSize(width: 300, height: 200)
    var backgroundColor = Color.gray.opacity(0.2)
    var cornerRadius = 12.0
    
    
    
    // MARK: - body
    var body: some View {
        Text(title)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .padding()
            .frame(width: customSize.width, height: customSize.height)
            .background(Rectangle().fill(backgroundColor).cornerRadius(cornerRadius))
    }
}



// MARK: - preview
struct ShapedText_Previews: PreviewProvider {
    static var previews: some View {
        ShapedText(title: "crypto asset")
    }
}
