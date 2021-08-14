//
//  TestsArticlePresenter.swift
//  SharedTests
//
//  Created by Mathias Remshardt on 07.02.21.
//

import Combine
@testable import dev_articles
import Foundation
import XCTest

class ArticleViewModelTests: XCTestCase {
  var articles: [Article]!
  var readingListItem: ReadingListItem!
  var useCaseFactory: MockArticleUseCaseFactory!
  var viewModel: ArticlesViewModel!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    articles = Article.createListFixture(min: 2)
    readingListItem = ReadingListItem(
      context: AppContainer.shared.managedObjectContext,
      from: articles[0],
      savedAt: Date()
    )
    useCaseFactory = MockArticleUseCaseFactory(
      loadArticlesUseCase: MockLoadArticlesUseCase(articles: articles),
      addReadingListItemFromArticleUseCase: MockAddReadingListItemFromArticleUseCase(readingListItem: readingListItem)
    )
    viewModel = ArticlesViewModel(articlesUseCaseFactory: useCaseFactory)

    cancellables = []
  }

  func testArticles_ShouldEmitEmptyListOnInit() {
    XCTAssertEqual(viewModel.articles, [])
  }

  func test_Articles_ShouldLoadInitialPage() {
    viewModel.nextArticles()

    XCTAssertEqual(viewModel.articles, articles)
  }

  func test_Articles_ShouldLoadNextPage() {
    viewModel.nextArticles()
    viewModel.nextArticles()

    XCTAssertEqual(viewModel.articles, articles + articles)
  }

  func test_Articles_ShouldLoadInitialPageWhenTimeCategoryChanges() {
    viewModel.nextArticles()
    viewModel.nextArticles()
    viewModel.selectedTimeCategory = .year

    XCTAssertEqual(viewModel.articles, articles)
  }

  func testToggleBookmark_ShouldToggleBookmarkBasedOnReadingListItem() {
    let oldArticle = articles[0]

    viewModel.toggleBookmark(oldArticle)

    XCTAssertNotEqual(viewModel.articles, articles)
  }
}
