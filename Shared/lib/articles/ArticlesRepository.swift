import Foundation
import Combine

enum TimeCategory {
  case feed
  case day
  case week
  case month
  case year
}

protocol ListArticle {
  func list$(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RestError>
}
