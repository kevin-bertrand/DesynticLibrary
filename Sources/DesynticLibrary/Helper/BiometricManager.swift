//
//  BiometricManager.swift
//  
//
//  Created by Kevin Bertrand on 16/01/2023.
//

import Foundation
import LocalAuthentication

class BiometricManager {
    static public func activateBiometric(message: String, completionHandler: @escaping (Bool) -> Void) {
        var error: NSError?
        let laContext = LAContext()
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = message
            
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                completionHandler(success)
            }
        }
    }
}
