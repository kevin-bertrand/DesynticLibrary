//
//  BiometricView.swift
//  
//
//  Created by Kevin Bertrand on 13/01/2023.
//

import LocalAuthentication
import SwiftUI

public struct BiometricView: View {
    // MARK: State properties
    @State private var isAvailable: Bool = false
    
    // MARK: Binding properties
    @Binding var condition: Bool
    
    // MARK: Properties
    private let laContext = LAContext()
    var action: () -> Void
    
    // MARK: Initialization
    public init(condition: Binding<Bool> = .constant(true),
                action: @escaping () -> Void) {
        self._condition = condition
        self.action = action
    }
    
    // MARK: Body
    public var body: some View {
        if isAvailable && condition  {
            VStack {
                Button {
                    action()
                } label: {
                    Image(systemName: (laContext.biometryType == .faceID) ? "faceid" : "touchid")
                        .resizable()
                        .frame(width: 75, height: 75)
                }
                .padding(.horizontal)
                .onAppear {
                    withAnimation {
                        isAvailable = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                                  error: .none)
                    }
                }
                
                Spacer()
            }
        } else {
            EmptyView()
        }
    }
}

struct BiometricView_Previews: PreviewProvider {
    static var previews: some View {
        BiometricView(action: {})
    }
}
