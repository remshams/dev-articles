//
//  StaticGetArticlesTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 06.08.21.
//

import Combine
@testable import dev_articles
import Foundation
import XCTest

class StaticGetArticleTest: XCTestCase {
  let article = Article.createFixture()
  var staticGetArticle: StaticGetArticle!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    staticGetArticle = StaticGetArticle(article: article)
    cancellables = []
  }

  func tests_getById_shouldReturnArticle() {
    collect(stream: staticGetArticle.getBy(id: article.id), cancellables: &cancellables)
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, [self.article])
      }
      .store(in: &cancellables)
  }

  func tests_getById_shouldReturnNilInCasePassedArticleIdDoesNotMatch() {
    collect(stream: staticGetArticle.getBy(id: "doesNotExist"), cancellables: &cancellables)
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, [nil])
      }
      .store(in: &cancellables)
  }

  func tests_getByUrl_shouldReturnArticle() {
    collect(stream: staticGetArticle.getBy(url: ArticleUrl(url: article.metaData.link)), cancellables: &cancellables)
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, [self.article])
      }
      .store(in: &cancellables)
  }

  func tests_getByUrl_shouldReturnNilIncaseArticleUrlDoesNotMatch() {
    collect(
      stream: staticGetArticle.getBy(url: ArticleUrl(url: URL(string: "other")!)),
      cancellables: &cancellables
    )
    .sink { _ in } receiveValue: {
      XCTAssertEqual($0, [nil])
    }
    .store(in: &cancellables)
  }
}
