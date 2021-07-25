//
//  LoadArticlesTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 02.05.21.
//

import Combine
@testable import dev_articles
import Foundation
import XCTest

class AppLoadArticlesTests: XCTestCase {
  var cancellables: Set<AnyCancellable>!
  var useCase: AppLoadArticlesUseCase!
  var articles: [Article]!

  override func setUp() {
    cancellables = []
    articles = Article.createListFixture(min: 2)
    useCase = AppLoadArticlesUseCase(
      listArticle: InMemoryListArticle(articles: articles),
      timeCategory: .day,
      page: 1, pageSize: 10
    )
  }

  func test_ShouldEmitArticlesList() {
    useCase.start()
      .sink {
        XCTAssertEqual($0, self.articles)
      }
      .store(in: &cancellables)
  }

  func test_ShouldEmitEmpyArrayWhenLoadingOfArticlesFails() {
    useCase = AppLoadArticlesUseCase(
      listArticle: FailingListArticle(listError: RepositoryError.error),
      timeCategory: .day,
      page: 1,
      pageSize: 10
    )

    useCase.start()
      .sink {
        XCTAssertEqual($0, [])
      }
      .store(in: &cancellables)
  }
}
