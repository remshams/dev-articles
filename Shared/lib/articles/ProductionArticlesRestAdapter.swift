import Foundation
import Combine

class ProductionArticlesRestAdapter: ArticlesRestAdapter {
  func list$() -> AnyPublisher<[Article], RestError> {
    return Just([Article(title: "title", id: 0, description: "description", published: false)])
      .setFailureType(to: RestError.self)
      .eraseToAnyPublisher()
  }
  
}
