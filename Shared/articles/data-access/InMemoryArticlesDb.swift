import Foundation
import Combine

class InMemoryArticlesDb: InMemoryRepository<Article>, ListArticle {

  init(articlesById: [Article.ID: Article] = [:]) {
    super.init(entitiesById: articlesById)
  }
  
  convenience init(articles: [Article]) {
    self.init(articlesById: articles.toDictionaryById())
  }
  
  func list$(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError> {
    super.list()
  }
  
}
