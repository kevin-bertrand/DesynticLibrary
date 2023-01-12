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
                DispatchQueue.global().async {
                    if !isAlreadyCheck {
                        self.checkAppVersion()
                    }
                }
            }
    }
    
    // MARK: Methods
    /// Getting current application version
    private func getCurrentAppVersion() -> String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// Getting AppStore version
    private func getAppStoreInformations() -> (String?, Int?) {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: Any],
              let result = (json["results"] as? [Any])?.first as? [String: Any],
              let version = result["version"] as? String,
              let trackId = result["trackId"] as? Int else {
            return (nil, nil)
        }
    
        return (version, trackId)
    }
        
    /// Checking app version according to the AppStore version
    private func checkAppVersion() {
        let (appStoreVersion, trackId) = getAppStoreInformations()
        
        guard let currentAppVersion = getCurrentAppVersion(),
              let appStoreVersion = appStoreVersion,
              let trackId = trackId,
              let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/id\(trackId)"),
              currentAppVersion != appStoreVersion else {
            return
        }
        
        self.isAlreadyCheck = true
        
        DispatchQueue.main.async {
            EmptyView()
                .alertView(title: mustUpdateTitle,
                           message: mustUpdateMessage,
                           primaryTitle: mustUpdateButton,
                           secondaryTitle: cancelButton,
                           primaryAction: {
                    if UIApplication.shared.canOpenURL(appStoreUrl) {
                        UIApplication.shared.open(appStoreUrl)
                    }
                })
        }
    }
}

extension View {
    /// Make a view a navigation Stack/View
    public func checkAppVersion(mustUpdateMessage: String, mustUpdateTitle: String, mustUpdateButton: String, cancelButton: String) -> some View {
        modifier(CheckAppVersion(mustUpdateMessage: mustUpdateMessage,
                                 mustUpdateTitle: mustUpdateTitle,
                                 mustUpdateButton: mustUpdateButton,
                                 cancelButton: cancelButton))
    }
}
