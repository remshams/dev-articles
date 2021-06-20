//
//  ArticleContentView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 19.06.21.
//

import Combine
import Foundation
import SwiftUI
import WebKit

struct ArticleContentView: View {
  var body: some View {
    WebView(text: "<h1>ArticleContent</h1>")
  }
}

private struct WebView: ViewRepresentable {
  let text: String

  func makeUIView(context _: Context) -> WKWebView {
    return WKWebView()
  }

  func updateUIView(_ uiView: WKWebView, context _: Context) {
    uiView.loadHTMLString(text, baseURL: nil)
  }

  func makeNSView(context _: Context) -> WKWebView { WKWebView() }
  func updateNSView(_ nsView: WKWebView, context _: Context) {
    nsView.loadHTMLString(text, baseURL: nil)
  }
}

#if os(macOS)
  public typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
  public typealias ViewRepresentable = UIViewRepresentable
#endif
