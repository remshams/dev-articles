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
  let articlePath = "articlePath"

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

    XCTAssertEqual(model.article, article)
  }

  // TODO Replace with error handling (message or the like)
  func test_loadArticle_shoudSetArticleToNilInCaseItCannotBeLoaded() {
    getArticle = FailingGetArticle(getError: .error)
    model = AddArticleViewModel(
      addArticle: addArticleDefault,
      cancelAddArticle: cancelAddArticeDefault,
      getArticle: getArticle
    )
    model.loadArticle(for: articlePath)

    XCTAssertNil(model.article)
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
    model.loadArticle(for: "link")
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
