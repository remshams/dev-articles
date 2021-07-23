import Combine
import Foundation
import OSLog

let articlesPath = "/articles"
enum ArticleQueryParam: String {
  case timeCategory = "top"
  case page = "page"
  case pageSize = "per_page"
}

struct AppArticlesRestAdapter: ArticlesRestAdapter {
  let httpGet: HttpGet

  init(httpGet: HttpGet) {
    self.httpGet = httpGet
  }

  func list(for timeCategory: TimeCategory, page: Int, pageSize: Int) -> AnyPublisher<[Article], RepositoryError> {
    httpGet.get(for: buildUrl(timeCategory: timeCategory, page: page, pageSize: pageSize))
      .decode()
      .toArticles()
      .mapError { error in
        Logger().debug("Requesting article list failed with: \(error.localizedDescription)")
        return RepositoryError.error
      }
      .eraseToAnyPublisher()
  }

  private func buildUrl(timeCategory: TimeCategory, page: Int, pageSize: Int) -> URL {
    var articlesUrlComponents = URLComponents(string: devCommunityUrl + articlesPath)!
    articlesUrlComponents.queryItems = [
      URLQueryItem(name: ArticleQueryParam.timeCategory.rawValue, value: String(TimeCategory.week.rawValue)),
      URLQueryItem(name: ArticleQueryParam.page.rawValue, value: String(page)),
      URLQueryItem(name: ArticleQueryParam.pageSize.rawValue, value: String(pageSize))
    ]
    return articlesUrlComponents.url!
  }
}
