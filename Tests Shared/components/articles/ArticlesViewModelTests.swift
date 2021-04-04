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
    assertStreamEquals(cancellables: &cancellables, received$: presenter.$articles.eraseToAnyPublisher(), expected: [[], articles])
  }
  
  func testArticles_ShouldEmitReloadedArticlesWhenTimeCategoryChanges() -> Void {
    let newArticles = [createArticleFixture(id: 99)]
    listArticleStatic.articles = newArticles
    presenter.selectedTimeCategory = .week
    assertStreamEquals(cancellables: &cancellables, received$: presenter.$articles.eraseToAnyPublisher(), expected: [[], articles, newArticles])
  }
  
  
  func testArticles_ShouldEmitEmpyArrayWhenLoadingOfArticlesFails() {
    prepareTest(shouldFail: true)
    assertStreamEquals(cancellables: &cancellables, received$: presenter.$articles.eraseToAnyPublisher(), expected: [[]])
  }
  
  func testToggleBookmark_ShouldToggleBookmarkforArticle() -> Void {
    let oldArticle = articles[0]
    var changedArticle = oldArticle
    changedArticle.bookmarked.toggle()
    
    settleStream(cancellables: &cancellables, received$: presenter.$articles.eraseToAnyPublisher(), waitFor: 2)
    presenter.toggleBookmark(oldArticle)
    
    assertStreamEquals(cancellables: &cancellables, received$: presenter.$articles.eraseToAnyPublisher(), expected: [[changedArticle] + articles[1..<articles.count]])
  }
  
  func testToggleBookmark_ShouldDoNothingInCaseBookmarkedArticleCannotBeFound() -> Void {
    settleStream(cancellables: &cancellables, received$: presenter.$articles.eraseToAnyPublisher(), waitFor: 2)
    presenter.toggleBookmark(createArticleFixture(id: 99))
    
    assertStreamEquals(cancellables: &cancellables, received$: presenter.$articles.eraseToAnyPublisher(), expected: [articles])
  }
  
}
