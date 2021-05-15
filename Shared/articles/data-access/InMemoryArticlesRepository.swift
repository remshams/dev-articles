import Combine
import Foundation

class InMemoryArticlesRepository: InMemoryRepository<Article>, ListArticle {
  init(articlesById: [Article.ID: Article] = [:]) {
    super.init(entitiesById: articlesById)
  }

  convenience init(articles: [Article]) {
    self.init(articlesById: articles.toDictionaryById())
  }

  func list(for _: TimeCategory) -> AnyPublisher<[Article], RepositoryError> {
    super.list()
  }

  func add(article: Article) -> AnyPublisher<Article, RepositoryError> {
    super.add(entity: article)
  }
}
