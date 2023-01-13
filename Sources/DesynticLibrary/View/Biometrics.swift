//
//  SwiftUIView.swift
//  
//
//  Created by Kevin Bertrand on 13/01/2023.
//

import LocalAuthentication
import SwiftUI

struct SwiftUIView: View {
    // MARK: State properties
    @State private var isAvailable: Bool = false
    
    // MARK: Properties
    var condition = true
    private let laContext = LAContext()
    var action: () -> Void
    
    // MARK: Body
    var body: some View {
        if isAvailable && condition  {
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
        } else {
            EmptyView()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(action: {})
    }
}
