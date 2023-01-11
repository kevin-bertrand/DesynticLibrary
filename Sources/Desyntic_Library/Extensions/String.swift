//
//  String.swift
//  
//
//  Created by Kevin Bertrand on 11/01/2023.
//

import Foundation
extension String {
    /// Determine if the string is an email or not
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    /// Determine if the string is a valid phone number
    var isPhone: Bool {
        let phoneRegEx = "^[\\+]?[(]?[0-9]{3}[)]?[-\\s\\.]?[0-9]{3}[-\\s\\.]?[0-9]{4,6}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePredicate.evaluate(with: self)
    }
    
    /// Determine if the string is a valid password
    var isPassword: Bool {
        return self.count > 3
    }
    
    /// Exporting String to date
    var toDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: self)
    }
}
