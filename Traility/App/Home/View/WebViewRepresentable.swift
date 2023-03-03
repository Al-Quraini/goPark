//
//  WebViewRepresentable.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/23/23.
//

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
