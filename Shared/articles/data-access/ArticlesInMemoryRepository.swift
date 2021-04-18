import Foundation
import Combine

class ArticlesInMemoryRepository: InMemoryRepository<Article>, ArticlesRepository {

  init(articlesById: [Article.ID: Article] = [:]) {
    super.init(entitiesById: articlesById)
  }
  
  convenience init(articles: [Article]) {
    self.init(articlesById: articles.toDictionaryById())
  }
  
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError> {
    super.list()
  }
  
  func add(article: Article) -> AnyPublisher<Article, RepositoryError> {
    super.add(entity: article)
  }
  
}
