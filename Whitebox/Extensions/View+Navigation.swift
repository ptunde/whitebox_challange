//
//  View+Navigation.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI



extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - binding: Only navigates when item != nil.
    ///   - destination: View to navigate to.
    func navigate<Item, Destination: View>(when binding: Binding<Item?>, @ViewBuilder destination: @escaping (Item) -> Destination) -> some View {
        NavigationStack {
            self.navigationDestination(isPresented: binding.asBool()) {
                if let item = binding.wrappedValue {
                    destination(item)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

