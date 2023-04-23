//
//  File.swift
//  
//
//  Created by Kevin Bertrand on 12/01/2023.
//

import Foundation
import SwiftUI

extension View {
    /// Showing alert view with text field
    public func alertWithTextField(title: String,
                            message: String,
                            hintText: String,
                            primaryTitle: String,
                            secondaryTitle: String,
                            primaryAction: @escaping (String) -> Void,
                            secondaryAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = hintText
        }
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
    
    /// Showing standard alert view
    public func alertView(title: String,
                   message: String,
                   primaryTitle: String,
                   secondaryTitle: String? = nil,
                   primaryAction: @escaping () -> Void,
                   secondaryAction: (() -> Void)? = {}) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        if let secondaryTitle = secondaryTitle,
           let secondaryAction = secondaryAction {
            alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
                secondaryAction()
            }))
        }
        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            primaryAction()
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
    
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
