//
//  Double.swift
//  
//
//  Created by Kevin Bertrand on 11/01/2023.
//

import Foundation

extension Double {
    /// Truncate a double to a two digits number
    public var twoDigitPrecision: String {
        return String(format: "%.2f", self)
    }
}
