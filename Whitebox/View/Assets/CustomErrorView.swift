//
//  CustomErrorView.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 09. 01..
//

import Foundation
import SwiftUI



// MARK: - error view
struct CustomErrorView: View {
    
    // MARK: - props
    let message: String
    let onRetry: () -> Void
    
    
    
    // MARK: - body
    var body: some View {
        VStack {
            Text(message)
            
            Button(action: onRetry, label: {
                Text("button_retry".localized())
                    .padding(6.0)
            })
            .buttonStyle(.bordered)
        }
    }
}



// MARK: - previews
struct CustomErrorView_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomErrorView(message: "unable_to_load_data".localized(),
                        onRetry: {})
    }
}
