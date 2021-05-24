import Combine
import Foundation

protocol ArticlesRepository: ListArticle {}

struct AppContainer {
  let httpGet: HttpGet
  let managedObjectContext = PersistenceController.shared.container.viewContext
  let readingListRepository: CoreDataReadingListRepository
  let articlesRepository: ArticlesRepository

  init() {
    httpGet = AppContainer.makeHttpGet()
    readingListRepository = CoreDataReadingListRepository(managedObjectContext: managedObjectContext)
    articlesRepository = AppContainer.makeArticlesRepository(httpGet: httpGet)
    print("Running with configuration: \(configuration)")
  }

  func makeArticlesContainer() -> ArticlesContainer {
    ArticlesContainer(listArticle: articlesRepository, addReadingListItem: readingListRepository)
  }

  private static func makeArticlesRepository(httpGet: HttpGet) -> ArticlesRepository {
    switch configuration {
    case Configuration.test:
      return InMemoryArticlesRepository()
    default:
      return AppArticlesRepository(httpGet: httpGet)
    }
  }

  func makeReadingListContainer() -> ReadingListContainer {
    ReadingListContainer(
      addReadingListItem: readingListRepository,
      listReadingListItem: readingListRepository
    )
  }

  private static func makeHttpGet() -> HttpGet {
    RestHttpClient()
  }
}

extension InMemoryArticlesRepository: ArticlesRepository {}
extension AppArticlesRepository: ArticlesRepository {}
