//
//  CheckAppVersion.swift
//  
//
//  Created by Kevin Bertrand on 12/01/2023.
//

import Foundation
import SwiftUI

struct CheckAppVersion: ViewModifier {
    // MARK: State properties
    @State private var isAlreadyCheck = false
    
    // MARK: Properties
    let mustUpdateMessage: String
    let mustUpdateTitle: String
    let mustUpdateButton: String
    let cancelButton: String
    
    // MARK: Body
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !isAlreadyCheck {
                    checkAppVersion()
                }
            }
    }
    
    // MARK: Methods
    /// Getting current application version
    private func getCurrentAppVersion() -> String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// Getting AppStore version
    private func getAppStoreVersion(url: URL) -> String? {
        guard let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: Any],
              let result = (json["result"] as? [Any])?.first as? [String: Any],
              let version = result["version"] as? String else {
            return nil
        }
        
        return version
    }
    
    /// Getting AppStore app url
    private func getAppStoreUrl() -> URL? {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            return nil
        }
        
        return url
    }
    
    /// Checking app version according to the AppStore version
    private func checkAppVersion() {
        guard let currentAppVersion = getCurrentAppVersion(),
              let url = getAppStoreUrl(),
              let appStoreVersion = getAppStoreVersion(url: url),
        currentAppVersion != appStoreVersion else {
            return
        }
        
        EmptyView()
            .alertView(title: mustUpdateTitle,
                       message: mustUpdateMessage,
                       primaryTitle: mustUpdateButton,
                       secondaryTitle: cancelButton,
                       primaryAction: {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
    }
}

extension View {
    /// Make a view a navigation Stack/View
    public func checkAppVersion(mustUpdateMessage: String, mustUpdateTitle: String, mustUpdateButton: String, cancelButton: String) -> some View {
        modifier(CheckAppVersion(mustUpdateMessage: mustUpdateMessage, mustUpdateTitle: mustUpdateTitle, mustUpdateButton: mustUpdateButton, cancelButton: cancelButton))
    }
}
