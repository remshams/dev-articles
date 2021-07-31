//
//  ArticlePathTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 29.07.21.
//

@testable import dev_articles
import Foundation
import XCTest

class ArticlePathTests: XCTestCase {
  let path = "samuelfaure/is-dev-to-victim-of-its-own-success-1ioj"
  let invalidUrlString = "top/week"
  var validUrlString: String!

  override func setUp() {
    validUrlString = "https://dev.to/\(path)"
  }

  func tests_init_shouldInitFromValidUrl() {
    XCTAssertEqual(ArticlePath(url: validUrlString)?.path, path)
  }

  func tests_init_shoudNotInitFromInvalidUrl() {
    XCTAssertNil(ArticlePath(url: invalidUrlString))
  }
}
