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

  var body: some View {
    Group {
      if !content.isEmpty {
        WebView(height: $webViewHeight, content: content.html)
      } else {
        Text("No Content")
      }
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

/**
 Handles navigations to embedded links
 Cannot be implemented on Coordinator as it is an internal class.
 The callback is not called in that case.
 */
public class NavigationHandler: NSObject, WKNavigationDelegate {
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

// MARK: WebView

private struct WebView {
  @Binding var height: CGFloat
  @Environment(\.colorScheme) var colorScheme
  let content: String
  let wkWebView: NoScrollWKWebView
  /**
   NavigationHandler is a defined as class property since the navigationHandlerDelegate is weak in WkWebView.
   This would lead to the handler being immediately disposed.
   */
  let navigationHandler = NavigationHandler()

  init(height: Binding<CGFloat>, content: String) {
    _height = height
    self.content = content
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
  class Coordinator: NSObject {
    var parent: WebView

    init(_ parent: WebView) {
      self.parent = parent
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
      parent.determineHeight()
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
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

  private func makeView(context _: Context) -> WKWebView {
    wkWebView.navigationDelegate = navigationHandler
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
                (img) => img.width !== 0 && img.height !== 0
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
