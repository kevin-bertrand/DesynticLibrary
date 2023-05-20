//
//  BiometricManager.swift
//  
//
//  Created by Kevin Bertrand on 16/01/2023.
//

import Foundation
import LocalAuthentication

public class BiometricManager: ObservableObject {
    // MARK: Static methods
    static private(set) var laContext = LAContext()
    static public func useBiometrics(message: String, password: String? = nil, completionHandler: @escaping (Bool) -> Void) {
        var error: NSError?
        
        if BiometricManager.laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = message
            
            BiometricManager.laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if let password,
                   success  {
                    BiometricManager.laContext.setCredential(password.data(using: .utf8), type: .applicationPassword)
                }
                completionHandler(success)
            }
        }
    }
    
    static var isActive: Bool {
        laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
    }
    
    static public var isBiometricsSet: Bool {
        laContext.isCredentialSet(.applicationPassword)
    }
}
