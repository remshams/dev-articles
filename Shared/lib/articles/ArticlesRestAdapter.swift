import Foundation
import Combine

protocol ArticlesRestAdapter {
  func list$() -> AnyPublisher<[Article], RestError>
}
