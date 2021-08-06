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
    model = ArticleContentViewModel(getArticle: getArticle, listArticleContent: listArticleContent, article: article)
    cancellables = []
  }

  func test_content_ShouldEmitEmptyArticleContentWhenNothingHasBeenLoaded() {
    XCTAssertEqual(model.content, ArticleContent.createEmpty())
  }

  func test_content_ShouldEmitLoadedArticleContent() {
    model.loadContent()

    XCTAssertEqual(model.content, articleContent)
  }

  func test_content_ShouldEmitEmptyArticleContentOnLoadError() {
    listArticleContent = FailingListArticleContent()
    model = ArticleContentViewModel(getArticle: getArticle, listArticleContent: listArticleContent, article: article)

    XCTAssertEqual(model.content, ArticleContent.createEmpty())
  }
}
