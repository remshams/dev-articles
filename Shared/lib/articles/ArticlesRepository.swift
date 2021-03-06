import Foundation
import Combine

enum TimeCategory {
  case feed
  case day
  case year
  case custom(days: String)
}

protocol ListArticle {
  func list$(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RestError>
}
