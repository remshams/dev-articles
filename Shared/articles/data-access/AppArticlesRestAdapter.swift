import Combine
import Foundation
import OSLog

let articlesPath = "/articles"

struct AppArticlesRestAdapter: ArticlesRestAdapter {
  let httpGet: HttpGet

  init(httpGet: HttpGet) {
    self.httpGet = httpGet
  }

  func list(for timeCategory: TimeCategory, page: Int, pageSize: Int) -> AnyPublisher<[Article], RepositoryError> {
    httpGet.get(for: buildUrl(timeCategory: timeCategory))
      .decode()
      .toArticles()
      .mapError { error in
        Logger().debug("Requesting article list failed with: \(error.localizedDescription)")
        return RepositoryError.error
      }
      .eraseToAnyPublisher()
  }

  private func buildUrl(timeCategory: TimeCategory) -> URL {
    var topParamValue: Int?
    switch timeCategory {
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
