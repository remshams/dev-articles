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
  let createAddArticle = { (exp: XCTestExpectation, article: Article) -> AddArticle in
    { articleReceived in
      XCTAssertEqual(articleReceived, article)
      exp.fulfill()
    }
  }

  override func setUp() {
    article = Article.createFixture()
    getArticle = MockGetArticle(article: article)
    model = AddArticleViewModel(
      addArticle: addArticleDefault,
      cancelAddArticle: cancelAddArticeDefault,
      getArticle: getArticle
    )
  }

  // MARK: Load Article

  func test_loadArticle_shouldLoadArticle() {
    model.loadArticle(for: articlePath)

    XCTAssertEqual(model.state, .articleLoaded(article))
  }

  func test_loadArticle_shouldLoadAndAddArticle() {
    let exp = expectation(description: #function)
    model = AddArticleViewModel(
      addArticle: createAddArticle(exp, article),
      cancelAddArticle: cancelAddArticeDefault,
      getArticle: getArticle
    )
    model.loadArticle(for: articlePath, shouldAdd: true)

    XCTAssertEqual(model.state, .articleLoaded(article))
    waitForExpectations(timeout: 2)
  }

  func test_loadArticle_shouldDisplayErrorMessageInCaseUrlIsInvalid() {
    model.loadArticle(for: "")

    XCTAssertEqual(model.state, .error(.urlInvalid))
  }

  func test_loadArticle_shouldDisplayErrorMessageInCaseUrlIsInvalidDevToUrl() {
    model.loadArticle(for: "https://www.apple.de")

    XCTAssertEqual(model.state, .error(.urlInvalid))
  }

  func test_loadArticle_shouldDisplayErrorMessageInCaseArticleCouldNotBeFound() {
    getArticle = MockGetArticle(article: nil)
    model = AddArticleViewModel(
      addArticle: addArticleDefault,
      cancelAddArticle: cancelAddArticeDefault,
      getArticle: getArticle
    )
    model.loadArticle(for: articlePath)

    XCTAssertEqual(model.state, .error(.notFound))
  }

  func test_loadArticle_shouldDisplayErrorMessageInCaseArticleCouldNotBeLoaded() {
    getArticle = FailingGetArticle(getError: .error)
    model = AddArticleViewModel(
      addArticle: addArticleDefault,
      cancelAddArticle: cancelAddArticeDefault,
      getArticle: getArticle
    )
    model.loadArticle(for: articlePath)

    XCTAssertEqual(model.state, .error(.notLoaded))
  }

  // MARK: Add article

  func test_add_shouldCallAddArticleCallback() {
    let exp = expectation(description: #function)
    model = AddArticleViewModel(
      addArticle: createAddArticle(exp, article),
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
