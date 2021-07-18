//
//  Application.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 18.07.21.
//

import Foundation
import WebKit
import SwiftUI

#if os(macOS)
  public typealias ViewRepresentable = NSViewRepresentable

  enum Application {
    static func openLink(url: URL) {
      NSWorkspace.shared.open(url)
    }
  }

#elseif os(iOS)
  public typealias ViewRepresentable = UIViewRepresentable

  enum Application {
    static func openLink(url: URL) {
      UIApplication.shared.open(url)
    }
  }
#endif
