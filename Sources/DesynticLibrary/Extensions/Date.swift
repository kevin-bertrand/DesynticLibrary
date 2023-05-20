//
//  Date.swift
//  
//
//  Created by Kevin Bertrand on 11/01/2023.
//

import Foundation

extension Date {
    /// Getting number of years since date
    public func getYearSinceDate() -> Int {
        let calendar = Calendar.current
        let date = Date()
        let currentYear = calendar.component(.year, from: date)
        let currentMonth = calendar.component(.month, from: date)
        let currentDay = calendar.component(.day, from: date)
        
        let birthdayYear = calendar.component(.year, from: self)
        let birthdayMonth = calendar.component(.month, from: self)
        let birthdayDay = calendar.component(.day, from: self)
        
        var years = currentYear - birthdayYear
        
        if currentMonth < birthdayMonth || (currentMonth == birthdayMonth && currentDay < birthdayDay) {
            years -= 1
        }
        
        return years
    }
    
    /// Return a date to a string dd/MM/YYYY
    public var asString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        return formatter.string(from: self)
    }
    
    public var day: Int { Calendar.current.component(.day, from: self) }
    public var month: Int { Calendar.current.component(.month, from: self) }
    public var year: Int { Calendar.current.component(.year, from: self) }
    
    public var hour: Int { Calendar.current.component(.hour, from: self) }
    public var minutes: Int { Calendar.current.component(.minute, from: self) }
    public var seconds: Int { Calendar.current.component(.second, from: self) }
}
