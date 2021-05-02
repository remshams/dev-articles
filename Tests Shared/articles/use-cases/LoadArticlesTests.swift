//
//  LoadArticlesTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 02.05.21.
//

import Foundation
import XCTest
import Combine
@testable import dev_articles

class LoadArticlesTests: XCTestCase {
  
  struct ListArticleStatic: InMemoryListArticle {
    var articles: [Article]
  }
  
  struct ListArticleFailing: FailingListArticle {
    let listError: RepositoryError
  }
  
  var cancellables: Set<AnyCancellable>!
  var useCase: LoadArticlesUseCase!
  var articles: [Article]!
  
  
  override func setUp() {
    cancellables = []
    articles = createArticlesListFixture(min: 2)
    useCase = LoadArticlesUseCase(listArticle: ListArticleStatic(articles: articles), timeCategory: .feed)
  }
  
  func test_ShouldEmitFeedList() {
    collect(stream$: useCase.start(), cancellables: &cancellables)
      .sink {
        XCTAssertEqual($0, [self.articles])
      }
      .store(in: &cancellables)
  }
  
  
  func test_ShouldEmitEmpyArrayWhenLoadingOfArticlesFails() {
    useCase = LoadArticlesUseCase(listArticle: ListArticleFailing(listError: RepositoryError.error), timeCategory: .feed)
    
    collect(stream$: useCase.start(), cancellables: &cancellables)
      .sink {
        XCTAssertEqual($0, [[]])
      }
      .store(in: &cancellables)
  }
  
}
