//
//  WebView.swift
//  
//
//  Created by Kevin Bertrand on 11/01/2023.
//

import Foundation
import SwiftUI
import WebKit

public class WebViewModel: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var url: URL?
    @Published var isLoading = true
    
    lazy var webView: WKWebView = {
        return WKWebView(frame: .zero)
    }()
    
    override init() {
        super.init()
        webView.navigationDelegate = self
    }
    
    /// Load URL strored in the @Published var url
    public func loadUrl() {
        DispatchQueue.main.async {
            guard let url = self.url else { return }
            self.webView.load(URLRequest(url: url))
        }
    }
    
    /// Display a html page
    public func display(_ html: String) {
        self.webView.loadHTMLString(html, baseURL: nil)
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.url = webView.url
            
            if self.url != nil {
                self.isLoading = false
            }
        }
    }
}

public struct WebView: UIViewRepresentable {
    @ObservedObject var webViewModel: WebViewModel
    
    public func makeUIView(context: Context) -> some UIView {
        return webViewModel.webView
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}
