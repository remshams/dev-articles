import Foundation
import Combine

struct AppContainer {
  
  let httpGet: HttpGet
  let managedObjectContext = PersistenceController.shared.container.viewContext
  let readingListRepository: ReadingListCoreDataRepository
  let articlesRepository: ArticlesRepository
  
  init() {
    httpGet = AppContainer.makeHttpGet()
    readingListRepository = ReadingListCoreDataRepository(managedObjectContext: managedObjectContext)
    articlesRepository = AppContainer.makeArticlesRepository(httpGet: httpGet)
  }
  
  func makeArticlesContainer() -> ArticlesContainer {
    return ArticlesContainer(listArticle: ArticlesRestAdapter(httpGet: httpGet), addReadingListItem: readingListRepository)
  }
  
  private static func makeArticlesRepository(httpGet: HttpGet) -> ArticlesRepository {
    switch configuration {
    case Configuration.test:
      return ArticlesInMemoryRepository()
    default:
      return ArticlesRestAdapter(httpGet: makeHttpGet())
    }
  }
  
  func makeReadingListContainer() -> ReadingListContainer {
    return ReadingListContainer(addReadingListItem: readingListRepository, listReadingListItem: readingListRepository)
  }
  
  private static func makeHttpGet() -> HttpGet {
    return RestHttpClient()
  }
  
}
