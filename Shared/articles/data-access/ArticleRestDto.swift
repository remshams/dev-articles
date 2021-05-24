import Combine
import Foundation

protocol ArticlesRestAdapter {
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError>
}


struct ArticleRestDto: Identifiable, Codable {
  let id: Int
  let title: String
  let description: String
  let url: String
}

func convertToArticle(articleDto: ArticleRestDto) -> Article {
  Article(
    title: articleDto.title,
    id: String(articleDto.id),
    description: articleDto.description,
    link: URL(string: articleDto.url)!
  )
}
