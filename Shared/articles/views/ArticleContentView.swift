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

struct Details: Codable {
  // swiftlint:disable:next all
  let body_html: String
}

struct ArticleContentView: View {
  var body: some View {
    Text("Text")
  }
}

private struct WebView: UIViewRepresentable {
  let text: String

  func makeUIView(context _: Context) -> WKWebView {
    return WKWebView()
  }

  func updateUIView(_ uiView: WKWebView, context _: Context) {
    uiView.loadHTMLString(text, baseURL: nil)
  }
}
