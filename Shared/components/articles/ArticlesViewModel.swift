import Foundation
import Combine

typealias BookmarkArticle = PassthroughSubject<ArticleId, Never>

class ArticlesViewModel: ObservableObject {
  private let listArticle: ListArticle
  private var cancellables: Set<AnyCancellable> = []
  
  private let loadArticles$ = PassthroughSubject<Void, Never>()
  
  let bookmarkArticle = PassthroughSubject<ArticleId, Never>()
  
  @Published private(set) var articles: [Article] = []
  @Published var selectedTimeCategory = TimeCategory.feed
  
  init(listArticle: ListArticle) {
    self.listArticle = listArticle
    
    setupLoadArticles()
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
  
  private func setupBookmarkArticle() -> Void {
    bookmarkArticle
      .compactMap({ bookmarkedArticleId in
        self.articles.first(where: { $0.id == bookmarkedArticleId })
      })
      .map { oldArticle -> Article in
        var newArticle = oldArticle
        newArticle.bookmarked = true
        return newArticle
      }
      .map {
        self.articles.replaceById(elementId: $0.id, newElement: $0)
      }
      .assign(to: \.articles, on: self)
      .store(in: &cancellables)
  }
  
}
