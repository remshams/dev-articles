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
  var articleLoader: ArticleLoader!
  var model: ArticleContentViewModel!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    article = Article.createFixture()
    articleContent = ArticleContent.createFixture()
    articleLoader = StaticArticleLoader(article: article)
    listArticleContent = MockListArticleContent(content: articleContent)
    model = ArticleContentViewModel(articleLoader: articleLoader, listArticleContent: listArticleContent)
    cancellables = []
  }

  func test_state_shouldBeInLoadingStateOnInit() {
    XCTAssertEqual(model.state, .loading)
  }

  func test_state_shouldBeInLoadedSateIfArticleAndContentCouldBeLoaded() {
    model.loadContent()

    XCTAssertEqual(model.state, .loaded(article, articleContent))
  }

  func test_state_shouldBeInErrorStateInCaseLoadingOfArticleFails() {
    articleLoader = GetArticleArticleLoader(getArticle: FailingGetArticle(getError: .error), articleId: article.id)
    model = ArticleContentViewModel(
      articleLoader: articleLoader,
      listArticleContent: listArticleContent
    )
    model.loadContent()

    XCTAssertEqual(model.state, .error)
  }

  func test_state_shouldBeInErrorStateInCaseLoadingOfArticleReturnsNil() {
    articleLoader = GetArticleArticleLoader(getArticle: MockGetArticle(article: nil), articleId: article.id)
    model = ArticleContentViewModel(
      articleLoader: articleLoader,
      listArticleContent: listArticleContent
    )
    model.loadContent()

    XCTAssertEqual(model.state, .error)
  }

  func test_state_shouldBeInErrorStateInCaseLoadingOfArticleContentFails() {
    listArticleContent = FailingListArticleContent()
    model = ArticleContentViewModel(
      articleLoader: articleLoader,
      listArticleContent: listArticleContent
    )
    model.loadContent()

    XCTAssertEqual(model.state, .error)
  }
}
