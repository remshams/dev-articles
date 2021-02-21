import Foundation
import Combine

struct InMemoryArticlesDb: ListArticle {
  private var articlesById: [Article.ID: Article]
  
  init(articlesById: [Article.ID: Article] = [:]) {
    self.articlesById = articlesById
  }
  
  init(articles: [Article]) {
    self.init(articlesById: articles.toDictionaryById())
  }
  
  func list$() -> AnyPublisher<[Article], RestError> {
    Just(Array(articlesById.values)).setFailureType(to: RestError.self).eraseToAnyPublisher()
  }
  
}
