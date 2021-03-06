import Foundation
import Combine

class ArticlesRestAdapter: ListArticle {
  func list$(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RestError> {
    return URLSession.shared.dataTaskPublisher(for: URL(string: "https://dev.to/api/articles?top=7")!)
      .map(\.data)
      .decode(type: [ArticleDto].self, decoder: JSONDecoder())
      .map() { artciles in
        artciles.map() { Article(title: $0.title, id: $0.id, description: $0.description, link: URL(string: $0.url)!) }
      }
      .mapError() { error in RestError.serverError }
      .eraseToAnyPublisher()
  
  }
  
}
