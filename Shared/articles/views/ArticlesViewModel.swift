import Combine
import Foundation

typealias ToggleBookmark = (Article) -> Void

class ArticlesViewModel: ObservableObject {
  private let articlesUseCaseFactory: ArticlesUseCaseFactory
  private var cancellables: Set<AnyCancellable> = []
  private let loadArticlesSubject = PassthroughSubject<Int, Never>()
  private let toggleBookmarkSubject = PassthroughSubject<Article, Never>()
  private let readingListItemAdded = PassthroughSubject<ReadingListItem, Never>()

  let toggleBookmark: ToggleBookmark

  @Published private(set) var articles: [Article] = []
  @Published private var currentPage = 1
  @Published var selectedTimeCategory = TimeCategory.day {
    didSet {
      currentPage = 1
      articles = []
      loadArticlesSubject.send(currentPage)
    }
  }

  init(articlesUseCaseFactory: ArticlesUseCaseFactory) {
    self.articlesUseCaseFactory = articlesUseCaseFactory
    toggleBookmark = toggleBookmarkSubject.send

    setupLoadArticles()
    setupAddReadingListItem()
    setupBookmarkArticle()
  }

  func loadArticles() {
    loadArticlesSubject.send(currentPage)
    currentPage += 1
  }

  private func setupLoadArticles() {
    loadArticlesSubject.combineLatest($selectedTimeCategory).flatMap { currentPage, timeCategory in
      self.articlesUseCaseFactory.makeLoadArticlesUseCase(timeCategory: timeCategory, page: currentPage)
        .start()
    }
    .map {
      self.articles + $0
    }
    .assign(to: \.articles, on: self)
    .store(in: &cancellables)
  }

  private func setupAddReadingListItem() {
    toggleBookmarkSubject
      .flatMap {
        self.articlesUseCaseFactory.makeAddReadlingListItemFromArticleUseCase(article: $0).start()
      }
      .sink(receiveCompletion: { _ in }, receiveValue: readingListItemAdded.send)
      .store(in: &cancellables)
  }

  private func setupBookmarkArticle() {
    readingListItemAdded
      .compactMap { readingListItem in
        self.articles.first(where: { $0.id == readingListItem.contentId })
      }
      .map {
        self.articles.bookmark(articles: [$0])
      }
      .assign(to: \.articles, on: self)
      .store(in: &cancellables)
  }
}
