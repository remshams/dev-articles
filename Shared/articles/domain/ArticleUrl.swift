//
//  ArticlePath.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 31.07.21.
//

import Foundation

struct ArticleUrl {
  private static let pathRegexString = #"^(http(s)?:\/\/)?dev.to\/(?<path>[a-zA-z\d-]*\/[a-zA-Z\-\d]*)$"#

  let url: URL
  let path: String?

  init(url: URL) {
    self.url = url
    if let path = ArticleUrl.matchPath(url: url.absoluteString) {
      self.path = path
    } else {
      path = nil
    }
  }

  private static func matchPath(url: String) -> String? {
    guard let regex = try? NSRegularExpression(pattern: pathRegexString),
          let match = regex.firstMatch(in: url, range: NSRange(location: 0, length: url.count)),
          let pathIndex = Range(match.range(withName: "path"), in: url)
    else {
      return nil
    }
    return String(url[pathIndex])
  }
}
