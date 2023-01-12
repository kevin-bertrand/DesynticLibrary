//
//  FocusInput.swift
//  
//
//  Created by Kevin Bertrand on 11/01/2023.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct FocusInput: ViewModifier {
    // MARK: States
    @FocusState private var isFocused: Bool
    
    // MARK: Binding
    @Binding var selectedFocuseId: Int
    
    // MARK: Properties
    let totalInputs: Int
    let inputId: Int
    
    // MARK: Body
    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onSubmit {
                if inputId < totalInputs && inputId > 0 {
                    selectedFocuseId += 1
                } else {
                    selectedFocuseId = -1
                }
            }
            .onChange(of: selectedFocuseId) { newValue in
                isFocused = newValue == inputId
            }
            .onChange(of: isFocused) { newValue in
                if newValue && inputId < totalInputs {
                    selectedFocuseId = inputId
                }
            }
    }
}

struct FocusInputForiOS14: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    /// Make a view a navigation Stack/View
    @available(iOS 15.0, *)
    public func focusInput(totalInputs: Int, inputId: Int, currentFocusId: Binding<Int>) -> some View {
        return modifier(FocusInput(selectedFocuseId: currentFocusId,
                                   totalInputs: totalInputs,
                                   inputId: inputId))
    }
}
