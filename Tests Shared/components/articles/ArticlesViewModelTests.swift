//
//  TestsArticlePresenter.swift
//  SharedTests
//
//  Created by Mathias Remshardt on 07.02.21.
//

import Foundation
import XCTest
import Combine
@testable import dev_articles

class ArticleViewModelTests: XCTestCase {
  
  struct ListArticleStatic: InMemoryListArticle {
    var articles: [Article]
  }
  
  struct ListArticleFailing: FailingListArticle {
    let listError: RestError
  }
  
  let articles = createArticlesListFixture()
  var listArticle: ListArticle!
  var presenter: ArticlesViewModel!
  var cancellables: Set<AnyCancellable>!
  
  private func prepareTest(articles: [Article]? = nil, shouldFail: Bool = false) -> Void {
    let articlesForTest = articles ?? self.articles
    listArticle = shouldFail ? ListArticleFailing(listError: RestError.serverError) : ListArticleStatic(articles: articlesForTest)
    presenter = ArticlesViewModel(listArticle: listArticle)
    cancellables = []
  }
  
  override func setUp() {
    prepareTest()
  }
  
  override func tearDown() {
    cancellables = []
  }
  
  func testArticles_ShouldEmitFeedListOnInit() throws {
    assertStreamEquals(cancellables: &cancellables, received$: presenter.$articles.dropFirst().eraseToAnyPublisher(), expected: articles)
    
  }
  
  
  func testArticles_ShouldEmitEmpyArrayWhenLoadingOfArticlesFails() throws {
    prepareTest(shouldFail: true)
    presenter.loadArticles()
    let exp = expectation(description: "ArticleTitles")
    
    presenter.$articles.sink(receiveValue: { articleTtitlesReceived in
      XCTAssertEqual(articleTtitlesReceived, [])
      
      exp.fulfill()
      
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
  }
  
}
