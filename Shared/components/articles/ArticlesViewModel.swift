import Foundation
import Combine

typealias ToggleBookmark = (Article) -> Void

class ArticlesViewModel: ObservableObject {
  private let listArticle: ListArticle
  private var cancellables: Set<AnyCancellable> = []
  private let loadArticles$ = PassthroughSubject<Void, Never>()
  private let toggleBookmarkSubject = PassthroughSubject<Article, Never>()

  let toggleBookmark: ToggleBookmark
  
  @Published private(set) var articles: [Article] = []
  @Published var selectedTimeCategory = TimeCategory.feed
  
  init(listArticle: ListArticle) {
    self.listArticle = listArticle
    toggleBookmark = toggleBookmarkSubject.send
    
    setupLoadArticles()
    setupToggleBookmark()
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
  
  private func setupToggleBookmark() -> Void {
    toggleBookmarkSubject
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
