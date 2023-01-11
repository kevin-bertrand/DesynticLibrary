//
//  NavigationLinkPresentation.swift
//  
//
//  Created by Kevin Bertrand on 11/01/2023.
//

import Foundation
import SwiftUI

struct NavigationLinkPresentation: ViewModifier {
    // MARK: Binding properties
    @Binding var isPresented: Bool
    
    // MARK: Properties
    var desination: AnyView
    
    // MARK: Body
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .navigationDestination(isPresented: $isPresented, destination: { desination })
        } else {
            VStack {
                content
                NavigationLink(destination: desination, isActive: $isPresented, label: { EmptyView()})
            }
        }
    }
}

extension View {
    /// Setting a navigation link
    public func navigationLinkPresentation(destination: AnyView, isPresented: Binding<Bool>) -> some View {
        modifier(NavigationLinkPresentation(isPresented: isPresented, desination: destination))
    }
}
