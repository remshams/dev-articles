import Foundation
import Combine


struct AppContainer {
  
  let httpGet: HttpGet
  
  init() {
    httpGet = AppContainer.makeHttpGet()
  }
  
  func makeArticlesContainer() -> ArticlesContainer {
    return ArticlesContainer(listArticle: ArticlesRestAdapter(httpGet: httpGet))
  }
  
  private static func makeHttpGet() -> HttpGet {
    return RestHttpClient()
  }
  
}

