import Foundation
import Combine

struct ArticlesRestAdapter: ArticlesRepository {
  func list$() -> AnyPublisher<[Article], RestError> {
    return Just([Article(title: "title", id: 0, description: "description", published: false)])
      .setFailureType(to: RestError.self)
      .eraseToAnyPublisher()
  }
  
}
