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
    articles = createArticlesListFixture(min: 2)
    useCase = AppLoadArticlesUseCase(listArticle: InMemoryListArticle(articles: articles), timeCategory: .feed)
  }

  func test_ShouldEmitFeedList() {
    collect(stream$: useCase.start(), cancellables: &cancellables)
      .sink {
        XCTAssertEqual($0, [self.articles])
      }
      .store(in: &cancellables)
  }

  func test_ShouldEmitEmpyArrayWhenLoadingOfArticlesFails() {
    useCase = AppLoadArticlesUseCase(
      listArticle: FailingListArticle(listError: RepositoryError.error),
      timeCategory: .feed
    )

    collect(stream$: useCase.start(), cancellables: &cancellables)
      .sink {
        XCTAssertEqual($0, [[]])
      }
      .store(in: &cancellables)
  }
}
