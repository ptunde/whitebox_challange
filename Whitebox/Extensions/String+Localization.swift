//
//  String+Localization.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 09. 01..
//

import Foundation



extension String {

    /// Fetches a localized String
    ///
    /// - Returns: return value(String) for key
    public func localized() -> String {
        let bundle = Bundle.init(identifier: "com.tunde.ios.Whitebox")
        return bundle!.localizedString(forKey: self, value: nil, table: nil)
    }


    /// Fetches a localised String Arguments
    ///
    /// - Parameter arguments: parameters to be added in a string
    /// - Returns: localized string
    public func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized(), locale: nil, arguments: arguments)
    }

}
