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

  func test_state_shouldEmitLoadingOnInit() {
    XCTAssertEqual(model.state, .loading)
  }

  func test_state_shouldEmitLoadedIfArticleAndContentCouldBeLoaded() {
    model.loadContent()

    XCTAssertEqual(model.state, .loaded(article, articleContent))
  }

  func test_state_shouldEmitErrorInCaseLoadingOfArticleFails() {
    articleLoader = GetArticleArticleLoader(getArticle: FailingGetArticle(getError: .error), articleId: article.id)
    model = ArticleContentViewModel(
      articleLoader: articleLoader,
      listArticleContent: listArticleContent
    )
    model.loadContent()

    XCTAssertEqual(model.state, .error)
  }

  func test_state_shouldEmitErrorInCaseLoadingOfArticleReturnsNil() {
    articleLoader = GetArticleArticleLoader(getArticle: MockGetArticle(article: nil), articleId: article.id)
    model = ArticleContentViewModel(
      articleLoader: articleLoader,
      listArticleContent: listArticleContent
    )
    model.loadContent()

    XCTAssertEqual(model.state, .error)
  }

  func test_state_shouldEmitErrorInCaseLoadingOfArticleContentFails() {
    listArticleContent = FailingListArticleContent()
    model = ArticleContentViewModel(
      articleLoader: articleLoader,
      listArticleContent: listArticleContent
    )
    model.loadContent()

    XCTAssertEqual(model.state, .error)
  }
}
