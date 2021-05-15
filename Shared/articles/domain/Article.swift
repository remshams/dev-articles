import Combine
import Foundation

typealias ArticleId = String

enum TimeCategory {
  case feed
  case day
  case week
  case month
  case year
}

protocol ListArticle {
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError>
}

struct Article: Identifiable, Equatable {
  let title: String
  let id: ArticleId
  let description: String
  let link: URL
  var bookmarked: Bool = false
}
