import Foundation
import Combine

enum TimeCategory {
  case feed
  case day
  case week
  case month
  case year
  case custom(days: Int)
}

protocol ListArticle {
  func list$(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RestError>
}
