//
//  BiometricView.swift
//  
//
//  Created by Kevin Bertrand on 13/01/2023.
//

import SwiftUI

public struct BiometricView: View {
    // MARK: State properties
    @StateObject private var biometricManager: BiometricManager
    
    // MARK: Binding properties
    @Binding var condition: Bool
    
    // MARK: Properties
    var action: () -> Void
    
    // MARK: Initialization
    public init(condition: Binding<Bool> = .constant(true),
                action: @escaping () -> Void) {
        self._biometricManager = StateObject(wrappedValue: BiometricManager())
        self._condition = condition
        self.action = action
    }
    
    // MARK: Body
    public var body: some View {
        Group {
            if BiometricManager.isActive && condition  {
                VStack {
                    Button {
                        action()
                    } label: {
                        Image(systemName: (BiometricManager.laContext.biometryType == .faceID) ? "faceid" : "touchid")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .padding()
                }
            } else {
                EmptyView()
            }
        }
    }
}

struct BiometricView_Previews: PreviewProvider {
    static var previews: some View {
        BiometricView(action: {})
    }
}
