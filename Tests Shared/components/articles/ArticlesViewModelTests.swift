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
  
  let articles = createArticlesListFixture(min: 2)
  var listArticle: ListArticle!
  var listArticleStatic: ListArticleStatic!
  var listArticleFailing: ListArticleFailing!
  var presenter: ArticlesViewModel!
  var cancellables: Set<AnyCancellable>!
  
  private func prepareTest(articles: [Article]? = nil, shouldFail: Bool = false) -> Void {
    let articlesForTest = articles ?? self.articles
    listArticleStatic = ListArticleStatic(articles: articlesForTest)
    listArticleFailing = ListArticleFailing(listError: RestError.serverError)
    listArticle = shouldFail ? listArticleFailing : listArticleStatic
    presenter = ArticlesViewModel(listArticle: listArticle)
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
    waitFor(stream$: presenter.$articles.eraseToAnyPublisher(), waitFor: 2, cancellables: &cancellables)
    let newArticles = [createArticleFixture(id: 99)]
    listArticleStatic.articles = newArticles
    presenter.selectedTimeCategory = .week
    
    collect(stream$: presenter.$articles.eraseToAnyPublisher(), collect: 2, cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual([self.articles, newArticles], $0) })
      .store(in: &cancellables)
  }
  
  
  func testArticles_ShouldEmitEmpyArrayWhenLoadingOfArticlesFails() {
    prepareTest(shouldFail: true)
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
  
}
