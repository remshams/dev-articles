import Combine
import Foundation

class InMemoryArticlesRepository: InMemoryRepository<Article>, ListArticle {
  init(articlesById: [Article.ID: Article] = [:]) {
    super.init(entitiesById: articlesById)
  }

  convenience init(articles: [Article]) {
    self.init(articlesById: articles.toDictionaryById())
  }

  func list(for _: TimeCategory, page _: Int, pageSize _: Int) -> AnyPublisher<[Article], RepositoryError> {
    super.list()
  }

  func add(article: Article) -> AnyPublisher<Article, RepositoryError> {
    super.add(entity: article)
  }

  func getBy(url _: ArticleUrl) -> AnyPublisher<Article?, RepositoryError> {
    Just(articleForPreview).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }

  func getBy(id _: ArticleId) -> AnyPublisher<Article?, RepositoryError> {
    Just(articleForPreview).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}
