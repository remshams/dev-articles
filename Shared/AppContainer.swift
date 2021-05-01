import Foundation
import Combine

protocol AppArticlesRepository: ListArticle {}

struct AppContainer {
  
  let httpGet: HttpGet
  let managedObjectContext = PersistenceController.shared.container.viewContext
  let readingListRepository: ReadingListCoreDataRepository
  let articlesRepository: AppArticlesRepository
  
  init() {
    httpGet = AppContainer.makeHttpGet()
    readingListRepository = ReadingListCoreDataRepository(managedObjectContext: managedObjectContext)
    articlesRepository = AppContainer.makeArticlesRepository(httpGet: httpGet)
    print("Running with configuration: \(configuration)")
  }
  
  func makeArticlesContainer() -> ArticlesContainer {
    return ArticlesContainer(listArticle: articlesRepository, addReadingListItem: readingListRepository)
  }
  
  private static func makeArticlesRepository(httpGet: HttpGet) -> AppArticlesRepository {
    switch configuration {
    case Configuration.test:
      return InMemoryArticlesRepository()
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

extension InMemoryArticlesRepository: AppArticlesRepository {}
