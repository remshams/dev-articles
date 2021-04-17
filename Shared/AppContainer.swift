import Foundation
import Combine


struct AppContainer {
  
  let httpGet: HttpGet
  let managedObjectContext = PersistenceController.shared.container.viewContext
  
  init() {
    httpGet = AppContainer.makeHttpGet()
  }
  
  func makeArticlesContainer() -> ArticlesContainer {
    return ArticlesContainer(listArticle: ArticlesRestAdapter(httpGet: httpGet))
  }
  
  func makeReadingListContainer() -> ReadingListContainer {
    let readingListRepository = ReadingListCoreDataRepository(managedObjectContext: managedObjectContext)
    return ReadingListContainer(addReadingListItem: readingListRepository, listReadingListItem: readingListRepository)
  }
  
  private static func makeHttpGet() -> HttpGet {
    return RestHttpClient()
  }
  
}

