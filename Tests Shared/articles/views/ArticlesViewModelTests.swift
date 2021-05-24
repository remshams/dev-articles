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
    collect(stream$: viewModel.$articles.eraseToAnyPublisher(), cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual($0, [self.articles]) })
      .store(in: &cancellables)
  }

  func testToggleBookmark_ShouldToggleBookmarkforArticle() {
    let oldArticle = articles[0]
    var changedArticle = oldArticle
    changedArticle.bookmarked.toggle()

    waitFor(stream$: viewModel.$articles.eraseToAnyPublisher(), waitFor: 1, cancellables: &cancellables)
    viewModel.toggleBookmark(oldArticle)

    collect(stream$: viewModel.$articles.eraseToAnyPublisher(), cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual($0, [[changedArticle] + self.articles[1 ..< self.articles.count]]) })
      .store(in: &cancellables)
  }
}
