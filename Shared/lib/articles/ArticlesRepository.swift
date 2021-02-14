import Foundation
import Combine

protocol ArticlesRepository {
  func list$() -> AnyPublisher<[Article], RestError>
}
