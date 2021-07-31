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
  var urlCalled: CurrentValueSubject<[URL], Never>!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    cancellables = []
    urlCalled = CurrentValueSubject<[URL], Never>([])
    articleDto = ArticleRestDto.createFixture()
    article = articleDto.toArticle()
    client = MockHttpGet(getResponse: articleDto, urlCalledSubject: urlCalled)
    adapter = AppArticlesRestAdapter(httpGet: client)
  }

  func test_getBy_returnsArticle() {
    let path = "first/second"
    let articleCompoenents = URLComponents(string: articlesUrl + path)!

    adapter.getBy(url: path)
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

  func test_getBy_ignoresSlashAtTheBeginning() {
    let path = "/first/second"
    let articleCompoenents = URLComponents(string: articlesUrl + path)!

    adapter.getBy(url: path)
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

  func test_getBy_returnsNilInCaseArticleCannotBeFound() {
    let path = "first/second"
    let clientFailing = FailingHttpGet(error: .notFound)
    adapter = AppArticlesRestAdapter(httpGet: clientFailing)
    let exp = expectation(description: #function)

    adapter.getBy(url: path)
      .sink { completion in
        switch completion {
        case let .failure(error): XCTFail("Failed with: \(error)")
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
