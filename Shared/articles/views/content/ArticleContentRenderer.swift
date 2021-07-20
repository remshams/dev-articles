//
//  ArticleContent.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 20.06.21.
//

import Foundation
import SwiftUI
import WebKit

struct ArticleContentWebView: View {
  let content: ArticleContent
  @Binding var webViewHeight: CGFloat
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    if !content.isEmpty {
      /**
       Currently a workaround to trigger a reload of the html content when the color scheme changes.
       That ways to rendered html aligns with the selected color scheme on change
       */
      if colorScheme == .light {
        WebView(height: $webViewHeight, content: content.html, colorScheme: .light)
      } else {
        WebView(height: $webViewHeight, content: content.html, colorScheme: .dark)
      }

    } else {
      Text("No Content")
    }
  }
}

public class NoScrollWKWebView: WKWebView {
  #if os(macOS)
    override public func scrollWheel(with theEvent: NSEvent) {
      nextResponder?.scrollWheel(with: theEvent)
    }

  #endif

  func disableScrolling() {
    #if os(iOS)
      scrollView.isScrollEnabled = false
    #endif
  }
}

// MARK: WebView

private struct WebView {
  @Binding var height: CGFloat
  let colorScheme: ColorScheme
  let content: String
  let wkWebView: NoScrollWKWebView

  init(height: Binding<CGFloat>, content: String, colorScheme: ColorScheme) {
    _height = height
    self.content = content
    self.colorScheme = colorScheme
    wkWebView = NoScrollWKWebView()
  }

  func determineHeight() {
    wkWebView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { height, _ in
      DispatchQueue.main.async {
        if let height = height as? CGFloat {
          self.height = height
        }
      }
    })
  }
}

// MARK: Coordinator

extension WebView {
  /**
   The navigationHandler is a weak property on WKWebView. Creating and assigning the Delegate when the WKWebView
   is created would immediately dispose it. The internal class avoids having to store the Delegate
   as a property on WebView.
   */
  class Coordinator: NSObject, WKNavigationDelegate {
    let onHeightChange: () -> Void

    init(onHeightChange: @escaping () -> Void) {
      self.onHeightChange = onHeightChange
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
      onHeightChange()
    }

    public func webView(
      _: WKWebView,
      decidePolicyFor navigationAction: WKNavigationAction,
      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
      guard navigationAction.navigationType == .linkActivated,
            let url = navigationAction.request.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let scheme = components.scheme,
            scheme == "http" || scheme == "https"
      else {
        decisionHandler(.allow)
        return
      }

      Application.openLink(url: url)
      decisionHandler(.cancel)
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(onHeightChange: determineHeight)
  }
}

// MARK: ViewRepresentable

extension WebView: ViewRepresentable {
  private static let hasLoadedScriptName = "hasLoadedHandler"

  func makeUIView(context: Context) -> WKWebView {
    makeView(context: context)
  }

  func updateUIView(_: WKWebView, context _: Context) {}

  func makeNSView(context: Context) -> WKWebView {
    makeView(context: context)
  }

  func updateNSView(_: WKWebView, context _: Context) {}

  private func makeView(context: Context) -> WKWebView {
    wkWebView.navigationDelegate = context.coordinator
    wkWebView.disableScrolling()
    addJs(with: MessageHandler(onMessage: determineHeight))
    addHtml()
    return wkWebView
  }

  private func addHtml() {
    let backgroundColor = colorScheme == .dark ? "black" : "white"
    let textColor = colorScheme == .dark ? "white" : "black"
    // swiftlint:disable line_length
    let htmlStart = """
      <HTML>
        <HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
      </HEAD>
        <BODY>
          <link rel="stylesheet" media="all" href="https://dev.to/assets/minimal-0b841ab3a60bd0e9f320c9b504d43494a1fd43a65a9cf0bf275d5d01bf35d465.css" id="secondary-minimal-stylesheet">
          <link rel="stylesheet" media="all" href="https://dev.to/assets/views-f79722b9dc450af7606743a3b1940be97bf007ce4b05ff81a51b35c25a74ab9f.css" id="secondary-views-stylesheet">
          <link rel="stylesheet" media="all" href="https://dev.to/assets/crayons-107b6803f42f9ecded114635c0f6941a825991e390716185c6764717f2e3dcb8.css" id="secondary-crayons-stylesheet">
          <div class="crayons-article__main" style="background-color: \(backgroundColor); color: \(textColor)">
            <div class="crayons-article__body text-styles spec__body">
    """
    let htmlEnd = """
            </div>
          </div>
        </BODY>
      </HTML>
    """
    // swiftlint:enable line_length
    wkWebView.loadHTMLString("\(htmlStart)\(content)\(htmlEnd)", baseURL: nil)
  }

  private func addJs(with handler: WKScriptMessageHandler) {
    let hasLoadedScript =
      """
          const handler = setInterval(() => {
            if (
              Array.from(document.querySelectorAll('img')).every(
                (img) => img.width !== undefined && img.height !== undefined && img.width > 0 && img.height > 0
              )
            ) {
              webkit.messageHandlers.\(WebView.hasLoadedScriptName).postMessage(true);
              clearInterval(handler);
            } else {
              webkit.messageHandlers.\(WebView.hasLoadedScriptName).postMessage(false);
            }
          }, 100);
      """
    wkWebView.configuration.userContentController.addUserScript(WKUserScript(
      source: hasLoadedScript,
      injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
      forMainFrameOnly: false
    ))
    wkWebView.configuration.userContentController.add(handler, name: WebView.hasLoadedScriptName)
  }
}

// MARK: MessageHandler

private class MessageHandler: NSObject, WKScriptMessageHandler {
  let onMessage: () -> Void

  init(onMessage: @escaping () -> Void) {
    self.onMessage = onMessage
  }

  func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
    if let isLoaded = message.body as? Bool, isLoaded == true {
      onMessage()
    }
  }
}
