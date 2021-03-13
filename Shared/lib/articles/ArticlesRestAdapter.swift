import Foundation
import Combine

let articlesPath = "/articles"

class ArticlesRestAdapter: ListArticle {
  let httpGet: HttpGet
  
  init(httpGet: HttpGet) {
    self.httpGet = httpGet
  }
  
  func list$(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RestError> {
    
    httpGet.get(for: buildUrl(timeCategory: timeCategory))
      .decode(type: [ArticleDto].self, decoder: JSONDecoder())
      .map() { articles in
        articles.map() { Article(title: $0.title, id: $0.id, description: $0.description, link: URL(string: $0.url)!) }
      }
      .mapError() { error in RestError.serverError }
      .eraseToAnyPublisher()
  
  }
  
  private func buildUrl(timeCategory: TimeCategory) -> URL {
    var topParamValue: Int?
    switch timeCategory {
    case .feed:
      topParamValue = nil
    case .day:
      topParamValue = 1
    case .week:
      topParamValue = 7
    case .month:
      topParamValue = 30
    case .year:
      topParamValue = 356
    case .custom(let days):
      topParamValue = days
    }
    if let topParamValue = topParamValue {
      return URL(string: devCommunityUrl + articlesPath + "?top=\(topParamValue)")!
    } else {
      return URL(string: devCommunityUrl + articlesPath)!
    }
  }
  
  
}
