import Combine
import CoreData
import Foundation

typealias ToggleBookmark = (Article) -> Void

class ArticlesViewModel: ObservableObject {
  private let articlesUseCaseFactory: ArticlesUseCaseFactory
  private var cancellables: Set<AnyCancellable> = []
  private let loadArticlesSubject = PassthroughSubject<(TimeCategory, Int), Never>()
  private let toggleBookmarkSubject = PassthroughSubject<Article, Never>()
  private let readingListItemAdded = PassthroughSubject<ReadingListItem, Never>()
  private let context: NSManagedObjectContext

  let toggleBookmark: ToggleBookmark

  @Published private(set) var articles: [Article] = []
  @Published private var currentPage = 1
  @Published var selectedTimeCategory = TimeCategory.day {
    didSet {
      currentPage = 1
      articles = []
      loadArticlesSubject.send((selectedTimeCategory, currentPage))
      currentPage += 1
    }
  }

  init(
    context: NSManagedObjectContext = AppContainer.shared.persistence.context,
    articlesUseCaseFactory: ArticlesUseCaseFactory
  ) {
    self.context = context
    self.articlesUseCaseFactory = articlesUseCaseFactory
    toggleBookmark = toggleBookmarkSubject.send

    setupLoadArticles()
    setupAddReadingListItem()
    setupBookmarkArticle()
  }

  func nextArticles() {
    loadArticlesSubject.send((selectedTimeCategory, currentPage))
    currentPage += 1
  }

  private func setupLoadArticles() {
    loadArticlesSubject.flatMap { timeCategory, currentPage in
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
      .map {
        $0.toReadingListItem(context: self.context)
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
