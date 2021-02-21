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
    let articles: [Article]
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
  
  func testArticles_ShouldEmitEmptyListOnInit() throws {
    let exp = expectation(description: "ArticleTitles")
    
    presenter.$articles.sink(receiveValue: {articlesReceived in
      
      XCTAssertEqual(articlesReceived, [])
      
      exp.fulfill()
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 2)
  }
  
  func testArticles_ShouldEmitWhenLoaded() throws {
    let exp = expectation(description: "ArticleTitles")
    presenter.loadArticles()
    
    presenter.$articles.sink(receiveValue: {articleTitlesReceived in
      XCTAssertEqual(articleTitlesReceived, self.articles)
      
      exp.fulfill()
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
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
