import Combine
import Foundation

let articlesPath = "/articles"

class AppArticlesRestAdapter: ArticlesRestAdapter {
  let httpGet: HttpGet

  init(httpGet: HttpGet) {
    self.httpGet = httpGet
  }

  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError> {
    httpGet.get(for: buildUrl(timeCategory: timeCategory))
      .decode(type: [ArticleRestDto].self, decoder: JSONDecoder())
      .toArticles()
      .mapError { _ in RepositoryError.error }
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
    }
    if let topParamValue = topParamValue {
      return URL(string: devCommunityUrl + articlesPath + "?top=\(topParamValue)")!
    } else {
      return URL(string: devCommunityUrl + articlesPath)!
    }
  }
}
