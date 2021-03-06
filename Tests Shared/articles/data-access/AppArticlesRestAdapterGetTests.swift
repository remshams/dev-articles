//
//  AppArticlesRestAdapterGetTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 27.07.21.
//

import Combine
@testable import dev_articles
import Foundation
import XCTest

class AppArticlesRestAdapterGetTests: XCTestCase {
  var articleDto: ArticleRestDto!
  var article: Article!
  var client: MockHttpGet<ArticleRestDto?>!
  var adapter: AppArticlesRestAdapter!
  var cancellables: Set<AnyCancellable>!
  let validArticleUrl = ArticleUrl(url: URL(string: validDevUrl)!)

  override func setUp() {
    cancellables = []
    articleDto = ArticleRestDto.createFixture()
    article = articleDto.toArticle()
    client = MockHttpGet(getResponse: articleDto)
    adapter = AppArticlesRestAdapter(httpGet: client)
  }

  func test_getById_returnsArticle() {
    collect(stream: adapter.getBy(id: article.id), cancellables: &cancellables)
      .sink { _ in } receiveValue: { XCTAssertEqual($0, [self.article]) }
      .store(in: &cancellables)

    client.urlCalledSubject
      .sink { _ in } receiveValue: { XCTAssertEqual($0, [URL(string: "\(articlesUrl)/\(self.article.id)")!]) }
      .store(in: &cancellables)
  }

  func test_getById_returnsNilInCaseArticleCannotBeFound() {
    let clientFailing = FailingHttpGet(error: .notFound)
    adapter = AppArticlesRestAdapter(httpGet: clientFailing)

    collect(stream: adapter.getBy(id: article.id), cancellables: &cancellables)
      .sink { _ in } receiveValue: { XCTAssertEqual($0, [nil]) }
      .store(in: &cancellables)
  }

  func test_getByUrl_returnsArticle() {
    let articleCompoenents = URLComponents(string: "\(articlesUrl)/\(validArticleUrl.path!)")!

    adapter.getBy(url: validArticleUrl)
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, self.article)
      }
      .store(in: &cancellables)

    client.urlCalledSubject
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, [articleCompoenents.url!])
      }
      .store(in: &cancellables)
  }

  func test_getByUrl_returnsNilInCaseArticleUrlIsNotValid() {
    let invalidArticleUrl = ArticleUrl(url: URL(string: "/invalid")!)
    let exp = expectation(description: #function)
    adapter.getBy(url: invalidArticleUrl).sink { _ in } receiveValue: {
      XCTAssertNil($0)
      exp.fulfill()
    }
    .store(in: &cancellables)

    waitForExpectations(timeout: 2)
  }

  func test_getByUrl_returnsNilInCaseArticleCannotBeFound() {
    let clientFailing = FailingHttpGet(error: .notFound)
    adapter = AppArticlesRestAdapter(httpGet: clientFailing)
    let exp = expectation(description: #function)

    adapter.getBy(url: validArticleUrl)
      .sink { completion in
        switch completion {
        case let .failure(error):
          XCTFail("Failed with: \(error)")
          exp.fulfill()
        case .finished: return
        }
      } receiveValue: {
        XCTAssertNil($0)
        exp.fulfill()
      }
      .store(in: &cancellables)

    waitForExpectations(timeout: 2)
  }
}
