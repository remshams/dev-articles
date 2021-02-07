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

class TestsArticlePresenter: XCTestCase {
  let articles = createArticlesListFixture()
  var articleTitles: [String]!
  var articleRestAdapter: MockArticlesRestAdapter!
  var presenter: ArticlesPresenter!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    articleTitles = articles.map({$0.title})
    articleRestAdapter = MockArticlesRestAdapter(articles: articles)
    presenter = ArticlesPresenter(articlesRestAdapter: articleRestAdapter)
    cancellables = []
  }
  
  func testArticleNamesShouldEmitEmptyListOnInit() throws {
    let exp = expectation(description: "ArticleNames")
    
    presenter.$articleTitles.sink(receiveValue: {articlesReceived in
      
      XCTAssertEqual(articlesReceived, [])
      
      exp.fulfill()
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 2)
  }
  
  func testArticleTitlesShouldEmitWhenLoaded() throws {
    let exp = expectation(description: "ArticleNames")
    presenter.loadArticles()
    
    presenter.$articleTitles.sink(receiveValue: {articleTitlesReceived in
      XCTAssertEqual(articleTitlesReceived, self.articleTitles)
      
      exp.fulfill()
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
  }
  
  // TODO Add test case when loading fails
  
}
