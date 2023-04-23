//
//  NavigationBackButton.swift
//  
//
//  Created by Kevin Bertrand on 11/01/2023.
//

import Foundation
import SwiftUI

struct NavigationBackButton: ViewModifier {
    // MARK: Environment
    @Environment(\.presentationMode) var presentation
    
    // MARK: Properties
    let title: String
    let action: () -> Void
    
    // MARK: Body
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 16.0, *) {
                content
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            getButton()
                        }
                    }
            } else {
                content
                    .navigationBarItems(leading: getButton())
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: Methods
    /// Getting button body
    private func getButtonBody() -> AnyView {
        return .init(HStack {
            Image(systemName: "chevron.left")
                .font(.body.bold())
            Text(title)
        }.offset(x: -7))
    }
    
    /// Getting actions
    private func getButton() -> AnyView {
        return .init(Button(action: {
            action()
            self.presentation.wrappedValue.dismiss()
        }, label: {getButtonBody()}))
    }
}

extension View {
    /// Customize back button navigation
    public func navigationBackButton(action: @escaping () -> Void, title: String) -> some View {
        modifier(NavigationBackButton(title: title, action: action))
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
