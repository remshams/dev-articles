//
//  ArticlePathTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 29.07.21.
//

@testable import dev_articles
import Foundation
import XCTest

class ArticleUrlTests: XCTestCase {
  let path = "samuelfaure123/is-dev-to-victim-of-its-own-success-1ioj"
  let invalidUrlString = "top/week"
  var validUrlString: String!
  var validUrl: URL!

  override func setUp() {
    validUrlString = "https://dev.to/\(path)"
    validUrl = URL(string: validUrlString)!
  }

  func tests_init_shouldInitFromValidUrl() {
    XCTAssertEqual(ArticleUrl(url: validUrl).path, path)
  }

  func tests_init_shoudNotInitFromInvalidUrl() {
    XCTAssertNil(ArticleUrl(url: URL(string: invalidUrlString)!).path)
  }
}
