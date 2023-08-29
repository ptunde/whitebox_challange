//
//  Binding+Optional.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 28..
//

import SwiftUI



extension Binding where Value == Bool {
    init<Wrapped>(bindingOptional: Binding<Wrapped?>) {
        self.init(get: { bindingOptional.wrappedValue != nil },
                  set: { newValue in
                            guard newValue == false else { return }
                            /// We only handle `false` booleans to set our optional to `nil`
                            /// as we can't handle `true` for restoring the previous value.
                            bindingOptional.wrappedValue = nil
                        })
    }
}



extension Binding {
    /// generating a Bool value from any Optional Binding
    func asBool<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        return Binding<Bool>(bindingOptional: self)
    }
}
