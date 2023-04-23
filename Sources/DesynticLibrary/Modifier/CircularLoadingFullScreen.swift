//
//  CircularLoadingFullScreen.swift
//  
//
//  Created by Kevin Bertrand on 11/01/2023.
//

import Foundation
import SwiftUI

struct CircularLoadingFullScreen: ViewModifier {
    // MARK: Binding
    @Binding var loading: Bool
    
    // MARK: Properties
    let backgroundColor: Color
    
    // MARK: Body
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if loading {
                backgroundColor
                    .ignoresSafeArea()
                
                CircularLoadingView()
            }
        }
    }
}

extension View {
    /// Make a view a navigation Stack/View
    public func circularWaitingFullScreen(loading: Binding<Bool>,
                                          backgroundColor: Color = .init(red: 0, green: 0, blue: 0, opacity: 0.34)) -> some View {
        modifier(CircularLoadingFullScreen(loading: loading, backgroundColor: backgroundColor))
    }
}
