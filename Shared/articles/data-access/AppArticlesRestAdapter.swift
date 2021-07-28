import Combine
import Foundation
import OSLog

let articlesUrl = "\(devCommunityUrl)/articles"
enum ArticleQueryParam: String {
  case timeCategory = "top"
  case page
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

  func getBy(path: String) -> AnyPublisher<Article?, RepositoryError> {
    let components = URLComponents(string: articlesUrl + "\(path)")!
    // TODO Implement case when 404 is returned by api in httpGet
    return httpGet.get(for: components.url!)
      .decode()
      .toArticle()
      .mapError { error in
        Logger().debug("Requesting article for path \(path) failed with: \(error.localizedDescription)")
        return RepositoryError.error
      }
      .eraseToAnyPublisher()
  }

  private func buildUrl(timeCategory: TimeCategory, page: Int, pageSize: Int) -> URL {
    var articlesUrlComponents = URLComponents(string: articlesUrl)!
    articlesUrlComponents.queryItems = [
      URLQueryItem(name: ArticleQueryParam.timeCategory.rawValue, value: String(timeCategory.rawValue)),
      URLQueryItem(name: ArticleQueryParam.page.rawValue, value: String(page)),
      URLQueryItem(name: ArticleQueryParam.pageSize.rawValue, value: String(pageSize))
    ]
    return articlesUrlComponents.url!
  }
}
