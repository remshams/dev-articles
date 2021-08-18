//
//  AddArticleViewModelTest.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 25.07.21.
//

@testable import dev_articles
import Foundation
import XCTest

class AddArticleViewModelTests: XCTestCase {
  var article: Article!
  var model: AddArticleViewModel!
  var getArticle: GetArticle!
  let addArticleDefault: AddArticle = { _ in }
  let cancelAddArticeDefault: CancelAddArticle = {}
  let articlePath = articleForPreview.metaData.link.absoluteString

  override func setUp() {
    article = Article.createFixture()
    getArticle = MockGetArticle(article: article)
    model = AddArticleViewModel(
      addArticle: addArticleDefault,
      cancelAddArticle: cancelAddArticeDefault,
      getArticle: getArticle
    )
  }

  func test_loadArticle_shouldLoadArticle() {
    model.loadArticle(for: articlePath)

    XCTAssertEqual(model.state, .articleLoaded(article))
  }

  // TODO: Replace with error handling (message or the like)
  func test_loadArticle_shouldDisplayErrorMessageInCaseUrlIsInvalid() {
    model.loadArticle(for: "")

    XCTAssertEqual(model.state, .error("Article Url invalid"))
  }

  func test_loadArticle_shouldDisplayErrorMessageInCaseUrlIsInvalidDevToUrl() {
    model.loadArticle(for: "https://www.apple.de")

    XCTAssertEqual(model.state, .error("Article Url invalid"))
  }

  func test_loadArticle_shouldDisplayErrorMessageInCaseArticleCouldNotBeFound() {
    getArticle = MockGetArticle(article: nil)
    model = AddArticleViewModel(
      addArticle: addArticleDefault,
      cancelAddArticle: cancelAddArticeDefault,
      getArticle: getArticle
    )
    model.loadArticle(for: articlePath)

    XCTAssertEqual(model.state, .error("Article not found"))
  }

  func test_loadArticle_shouldDisplayErrorMessageInCaseArticleCouldNotBeLoaded() {
    getArticle = FailingGetArticle(getError: .error)
    model = AddArticleViewModel(
      addArticle: addArticleDefault,
      cancelAddArticle: cancelAddArticeDefault,
      getArticle: getArticle
    )
    model.loadArticle(for: articlePath)

    XCTAssertEqual(model.state, .error("Article load error"))
  }

  func test_add_shouldCallAddArticleCallback() {
    let exp = expectation(description: #function)
    let addArticle: AddArticle = { articleReceived in
      XCTAssertEqual(articleReceived, self.article)
      exp.fulfill()
    }
    model = AddArticleViewModel(
      addArticle: addArticle,
      cancelAddArticle: cancelAddArticeDefault,
      getArticle: getArticle
    )
    model.loadArticle(for: articlePath)
    model.add()

    waitForExpectations(timeout: 2)
  }

  func test_add_shoudCallCancelCallbackWhenArticleNotSet() {
    let exp = expectation(description: #function)
    let cancelAddArticle = {
      exp.fulfill()
    }
    model = AddArticleViewModel(
      addArticle: addArticleDefault,
      cancelAddArticle: cancelAddArticle,
      getArticle: getArticle
    )
    model.add()

    waitForExpectations(timeout: 2)
  }
}
