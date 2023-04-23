//
//  AsNavigationView.swift
//  
//
//  Created by Kevin Bertrand on 11/01/2023.
//

import Foundation
import SwiftUI

struct AsNavigationView: ViewModifier {
    // MARK: Body
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
        }
    }
}

extension View {
    /// Make a view a navigation Stack/View
    public func asNavigationView() -> some View {
        modifier(AsNavigationView())
    }
}
