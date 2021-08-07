//
//  ArticleContentViewModelTest.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 04.07.21.
//

import Combine
@testable import dev_articles
import Foundation
import XCTest

class ArticleContentViewModelTest: XCTestCase {
  var article: Article!
  var articleContent: ArticleContent!
  var listArticleContent: ListArticleContent!
  var getArticle: GetArticle!
  var model: ArticleContentViewModel!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    article = Article.createFixture()
    articleContent = ArticleContent.createFixture()
    getArticle = MockGetArticle(article: article)
    listArticleContent = MockListArticleContent(content: articleContent)
    model = ArticleContentViewModel(
      getArticle: getArticle,
      listArticleContent: listArticleContent,
      articleId: article.id
    )
    cancellables = []
  }

  func test_state_shouldEmitLoadingOnInit() {
    XCTAssertEqual(model.state, .loading)
  }

  func test_state_shouldEmitLoadedIfArticleAndContentCouldBeLoaded() {
    model.loadContent()

    XCTAssertEqual(model.state, .loaded(article, articleContent))
  }

  func test_state_shouldEmitErrorInCaseLoadingOfArticleFails() {
    getArticle = FailingGetArticle(getError: .error)
    model = ArticleContentViewModel(
      getArticle: getArticle,
      listArticleContent: listArticleContent,
      articleId: article.id
    )
    model.loadContent()

    XCTAssertEqual(model.state, .error)
  }

  func test_state_shouldEmitErrorInCaseLoadingOfArticleReturnsNil() {
    getArticle = MockGetArticle(article: nil)
    model = ArticleContentViewModel(
      getArticle: getArticle,
      listArticleContent: listArticleContent,
      articleId: article.id
    )
    model.loadContent()

    XCTAssertEqual(model.state, .error)
  }

  func test_state_shouldEmitErrorInCaseLoadingOfArticleContentFails() {
    listArticleContent = FailingListArticleContent()
    model = ArticleContentViewModel(
      getArticle: getArticle,
      listArticleContent: listArticleContent,
      articleId: article.id
    )
    model.loadContent()

    XCTAssertEqual(model.state, .error)
  }
}
