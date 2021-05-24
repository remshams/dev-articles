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
    articles = createArticlesListFixture(min: 2)
    readingListItem = ReadingListItem(from: articles[0], savedAt: Date())
    useCaseFactory = MockArticleUseCaseFactory(
      loadArticlesUseCase: MockLoadArticlesUseCase(articles: articles),
      addReadingListItemFromArticleUseCase: MockAddReadingListItemFromArticleUseCase(readingListItem: readingListItem)
    )
    viewModel = ArticlesViewModel(articlesUseCaseFactory: useCaseFactory)

    cancellables = []
  }

  func testArticles_ShouldEmitOnInit() {
    XCTAssertEqual(viewModel.articles, articles)
  }

  func testToggleBookmark_ShouldToggleBookmarkBasedOnReadingListItem() {
    let oldArticle = articles[0]

    viewModel.toggleBookmark(oldArticle)

    XCTAssertNotEqual(viewModel.articles, articles)
  }
}
