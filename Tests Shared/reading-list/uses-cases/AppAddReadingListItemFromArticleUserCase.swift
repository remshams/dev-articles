//
//  AddReadingListItemFromArticleUserCase.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 23.05.21.
//

import Combine
@testable import dev_articles
import XCTest

class AppAddReadingListItemFromArticleUserCaseTests: XCTestCase {
  var addReadingListItem: AddReadingListItem!
  var useCase: AppAddReadingListItemFromArticleUseCase!
  var article: Article!
  var date: Date!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    article = createArticleFixture()
    date = Date()
    addReadingListItem = InMemoryAddReadingListItem(date: date)
    useCase = AppAddReadingListItemFromArticleUseCase(addReadingListItem: addReadingListItem, article: article)

    cancellables = []
  }

  func tests_ShouldAddArticleAsReadingListItem() {
    collect(stream: useCase.start(), cancellables: &cancellables)
      .sink(receiveCompletion: { _ in }) {
        XCTAssertEqual($0, [ReadingListItem(from: self.article, savedAt: self.date)])
      }
      .store(in: &cancellables)
  }

  func tests_ShouldReturnErrorInCaseAddingOfReadlingListItemFails() {
    let failingAddReadingListItem = FailingAddReadingListItem()
    useCase = AppAddReadingListItemFromArticleUseCase(addReadingListItem: failingAddReadingListItem, article: article)

    collect(stream: useCase.start(), cancellables: &cancellables)
      .sink(receiveCompletion: { _ in }) {
        XCTAssertEqual($0, [])
        XCTAssertTrue(failingAddReadingListItem.called)
      }
      .store(in: &cancellables)
  }
}
