//
//  LightGrayButtonSyle.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI



struct LightGrayButtonSyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label
            .background(configuration.isPressed ? .gray.opacity(0.2) : Color.white.opacity(0.01))
    }
}
