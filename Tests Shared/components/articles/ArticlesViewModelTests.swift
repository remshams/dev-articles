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
  var articleTitles: [String]!
  var listArticle: ListArticle!
  var presenter: ArticlesViewModel!
  var cancellables: Set<AnyCancellable>!
  
  private func prepareTest(articles: [Article]? = nil, shouldFail: Bool = false) -> Void {
    let articlesForTest = articles ?? self.articles
    articleTitles = articlesForTest.map({$0.title})
    listArticle = shouldFail ? ListArticleFailing(listError: RestError.serverError) : ListArticleStatic(articles: articlesForTest)
    presenter = ArticlesViewModel(listArticle: listArticle)
    cancellables = []
  }
  
  override func setUp() {
    prepareTest()
  }
  
  func testArticeTitles_ShouldEmitEmptyListOnInit() throws {
    let exp = expectation(description: "ArticleTitles")
    
    presenter.$articleTitles.sink(receiveValue: {articlesReceived in
      
      XCTAssertEqual(articlesReceived, [])
      
      exp.fulfill()
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 2)
  }
  
  func testArticleTitles_ShouldEmitWhenLoaded() throws {
    let exp = expectation(description: "ArticleTitles")
    presenter.loadArticles()
    
    presenter.$articleTitles.sink(receiveValue: {articleTitlesReceived in
      XCTAssertEqual(articleTitlesReceived, self.articleTitles)
      
      exp.fulfill()
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
  }
  
  func testArticleTitles_ShouldEmitEmpyArrayWhenLoadingOfArticlesFails() throws {
    prepareTest(shouldFail: true)
    presenter.loadArticles()
    let exp = expectation(description: "ArticleTitles")
    
    presenter.$articleTitles.sink(receiveValue: { articleTtitlesReceived in
      XCTAssertEqual(articleTtitlesReceived, [])
      
      exp.fulfill()
      
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
  }
  
}
