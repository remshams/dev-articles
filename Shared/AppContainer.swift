import Foundation
import Combine


struct AppContainer {
  
  let httpGet: HttpGet
  let managedObjectContext = PersistenceController.shared.container.viewContext
  let readingListRepository: ReadingListCoreDataRepository
  
  init() {
    httpGet = AppContainer.makeHttpGet()
    readingListRepository = ReadingListCoreDataRepository(managedObjectContext: managedObjectContext)
  }
  
  func makeArticlesContainer() -> ArticlesContainer {
    return ArticlesContainer(listArticle: ArticlesRestAdapter(httpGet: httpGet), addReadingListItem: readingListRepository)
  }
  
  func makeReadingListContainer() -> ReadingListContainer {
    return ReadingListContainer(addReadingListItem: readingListRepository, listReadingListItem: readingListRepository)
  }
  
  private static func makeHttpGet() -> HttpGet {
    return RestHttpClient()
  }
  
}

