import Foundation
import Combine

class InMemoryArticlesDb: ListArticle {
  private var articlesById: [Article.ID: Article]
  
  init(articlesById: [Article.ID: Article] = [:]) {
    self.articlesById = articlesById
  }
  
  convenience init(articles: [Article]) {
    self.init(articlesById: articles.toDictionaryById())
  }

  func add(article: Article) -> Void {
    articlesById[article.id] = article
  }
  
  func list$() -> AnyPublisher<[Article], RestError> {
    Just(Array(articlesById.values)).setFailureType(to: RestError.self).eraseToAnyPublisher()
  }
  
}
