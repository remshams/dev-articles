import Foundation
import Combine

typealias ToggleBookmark = (Article) -> Void

class ArticlesViewModel: ObservableObject {
  private let listArticle: ListArticle
  private let addReadingListItem: AddReadingListItem
  private var cancellables: Set<AnyCancellable> = []
  private let loadArticles$ = PassthroughSubject<Void, Never>()
  private let toggleBookmarkSubject = PassthroughSubject<Article, Never>()
  private let readingListItemAdded = PassthroughSubject<ReadingListItem, Never>()

  let toggleBookmark: ToggleBookmark
  
  @Published private(set) var articles: [Article] = []
  @Published var selectedTimeCategory = TimeCategory.feed
  
  init(listArticle: ListArticle, addReadingListItem: AddReadingListItem) {
    self.listArticle = listArticle
    self.addReadingListItem = addReadingListItem
    toggleBookmark = toggleBookmarkSubject.send
    
    setupLoadArticles()
    setupAddReadingListItem()
    setupBookmarkArticle()
    loadArticles()
  }
  
  func loadArticles() -> Void {
    loadArticles$.send()
  }
  
  
  private func setupLoadArticles() -> Void {
    $selectedTimeCategory.flatMap({ timeCategory in
      self.listArticle.list$(for: timeCategory)
    })
    .receive(on: DispatchQueue.main)
    .replaceError(with: [])
    .assign(to: \.articles, on: self)
    .store(in: &cancellables)
  }
  
  private func setupAddReadingListItem() -> Void {
    toggleBookmarkSubject
      .flatMap(addReadingListItem.addFrom)
      .sink(receiveCompletion: { _ in }, receiveValue: readingListItemAdded.send)
      .store(in: &cancellables)
      
  }
  
  private func setupBookmarkArticle() -> Void {
    readingListItemAdded
      .compactMap {readingListItem in
        self.articles.first(where: { $0.id == readingListItem.contentId })
      }
      .map { oldArticle in
        var newArticle = oldArticle
        newArticle.bookmarked.toggle()
        return newArticle
      }
      .map {
        self.articles.replaceById(elementId: $0.id, newElement: $0)
      }
      .assign(to: \.articles, on: self)
      .store(in: &cancellables)
  }
  
}
