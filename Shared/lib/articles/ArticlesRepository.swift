import Foundation
import Combine

protocol ListArticle {
  func list$() -> AnyPublisher<[Article], RestError>
}
