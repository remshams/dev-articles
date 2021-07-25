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
  let addArticleDefault: AddArticle = { _ in }
  let cancelAddArticeDefault: CancelAddArticle = {}

  override func setUp() {
    article = articleForPreview
  }

  func test_add_shouldCallAddArticleCallback() {
    let exp = expectation(description: #function)
    let addArticle: AddArticle = { articleReceived in
      XCTAssertEqual(articleReceived, self.article)
      exp.fulfill()
    }
    model = AddArticleViewModel(addArticle: addArticle, cancelAddArticle: cancelAddArticeDefault)
    model.loadArticle(for: "link")
    model.add()

    waitForExpectations(timeout: 2)
  }

  func test_add_shoudCallCancelCallbackWhenArticleNotSet() {
    let exp = expectation(description: #function)
    let cancelAddArticle = {
      exp.fulfill()
    }
    model = AddArticleViewModel(addArticle: addArticleDefault, cancelAddArticle: cancelAddArticle)
    model.add()

    waitForExpectations(timeout: 2)
  }
}
