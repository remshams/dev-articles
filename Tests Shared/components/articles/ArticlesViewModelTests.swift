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

class ArticleViewModelTests: XCTestCase {
  
  class ListArticleStatic: InMemoryListArticle {
    
    init(articles: [Article]) {
      self.articles = articles
    }
    
    var articles: [Article]
  }
  
  struct ListArticleFailing: FailingListArticle {
    let listError: RestError
  }
  
  struct AddReadingListItemSuccess: InMemoryAddReadingListItem {}
  struct AddReadingListItemFailing: FailingAddReadingListItem {}
  
  let articles = createArticlesListFixture(min: 2)
  var presenter: ArticlesViewModel!
  var cancellables: Set<AnyCancellable>!
  
  private func prepareTest(articles: [Article]? = nil, listArticle: ListArticle? = nil, addReadingListItem: AddReadingListItem? = nil) -> Void {
    let articlesForTest = articles ?? self.articles
    presenter = ArticlesViewModel(listArticle: listArticle ?? ListArticleStatic(articles: articlesForTest), addReadingListItem: addReadingListItem ?? AddReadingListItemSuccess())
    cancellables = []
  }
  
  override func setUp() {
    prepareTest()
  }
  
  override func tearDown() {
    cancellables = []
  }
  
  func testArticles_ShouldEmitFeedListOnInit() {
    collect(stream$: presenter.$articles.eraseToAnyPublisher(), collect: 2, cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual([[], self.articles], $0) })
      .store(in: &cancellables)
  }
  
  func testArticles_ShouldEmitReloadedArticlesWhenTimeCategoryChanges() -> Void {
    let listArticleStatic = ListArticleStatic(articles: articles)
    prepareTest(listArticle: listArticleStatic)
    waitFor(stream$: presenter.$articles.eraseToAnyPublisher(), waitFor: 2, cancellables: &cancellables)
    let newArticles = [createArticleFixture(id: 99)]
    listArticleStatic.articles = newArticles
    presenter.selectedTimeCategory = .week
    
    collect(stream$: presenter.$articles.eraseToAnyPublisher(), collect: 2, cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual([self.articles, newArticles], $0) })
      .store(in: &cancellables)
  }
  
  
  func testArticles_ShouldEmitEmpyArrayWhenLoadingOfArticlesFails() {
    let listArticle = ListArticleFailing(listError: RestError.serverError)
    prepareTest(listArticle: listArticle)
    collect(stream$: presenter.$articles.eraseToAnyPublisher(), collect: 1, cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual([[]], $0) })
      .store(in: &cancellables)
  }
  
  func testToggleBookmark_ShouldToggleBookmarkforArticle() -> Void {
    let oldArticle = articles[0]
    var changedArticle = oldArticle
    changedArticle.bookmarked.toggle()
    
    waitFor(stream$: presenter.$articles.eraseToAnyPublisher(), waitFor: 2, cancellables: &cancellables)
    presenter.toggleBookmark(oldArticle)
    
    collect(stream$: presenter.$articles.eraseToAnyPublisher(), collect: 1, cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual([[changedArticle] + self.articles[1..<self.articles.count]], $0) })
      .store(in: &cancellables)
  }
  
  func testToggleBookmark_ShouldDoNothingInCaseBookmarkedArticleCannotBeFound() -> Void {
    waitFor(stream$: presenter.$articles.eraseToAnyPublisher(), waitFor: 2, cancellables: &cancellables)
    presenter.toggleBookmark(createArticleFixture(id: 99))
    
    
    collect(stream$: presenter.$articles.eraseToAnyPublisher(), collect: 1, cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual([self.articles], $0) })
      .store(in: &cancellables)
  }
  
  func testToggleBookmark_ShouldDoNothingInCaseBookmarkedArticleCannotBeAddedToDatabase() -> Void {
    prepareTest(addReadingListItem: AddReadingListItemFailing())
    waitFor(stream$: presenter.$articles.eraseToAnyPublisher(), waitFor: 2, cancellables: &cancellables)
    presenter.toggleBookmark(articles[0])
    
    
    collect(stream$: presenter.$articles.eraseToAnyPublisher(), collect: 1, cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual([self.articles], $0) })
      .store(in: &cancellables)
  }
  
}
