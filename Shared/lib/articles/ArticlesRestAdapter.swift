import Foundation
import Combine

class ArticlesRestAdapter: ListArticle {
  func list$() -> AnyPublisher<[Article], RestError> {
    return Just([Article(title: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel", id: 0, description: "description", published: false)])
      .setFailureType(to: RestError.self)
      .eraseToAnyPublisher()
  }
  
}
