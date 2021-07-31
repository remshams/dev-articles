import Combine
import Foundation

protocol ArticlesRepository: ListArticle, GetArticle {}
protocol ArticleContentRepository: ListArticleContent {}

struct AppContainer {
  let httpGet: HttpGet
  let managedObjectContext = PersistenceController.shared.container.viewContext
  let readingListRepository: CoreDataReadingListRepository
  let articlesRepository: ArticlesRepository
  let articleContentRepository: ArticleContentRepository

  init() {
    httpGet = AppContainer.makeHttpGet()
    readingListRepository = CoreDataReadingListRepository(managedObjectContext: managedObjectContext)
    articlesRepository = AppContainer.makeArticlesRepository(httpGet: httpGet)
    articleContentRepository = AppContainer.makeArticleContentRepository(httpGet: httpGet)
    print("Running with configuration: \(configuration)")
  }

  func makeArticlesContainer() -> ArticlesContainer {
    ArticlesContainer(
      listArticle: articlesRepository,
      listArticleContent: articleContentRepository,
      addReadingListItem: readingListRepository
    )
  }

  private static func makeArticlesRepository(httpGet: HttpGet) -> ArticlesRepository {
    switch configuration {
    case Configuration.test:
      return InMemoryArticlesRepository()
    default:
      return AppArticlesRepository(httpGet: httpGet)
    }
  }

  private static func makeArticleContentRepository(httpGet: HttpGet) -> ArticleContentRepository {
    switch configuration {
    case Configuration.test:
      return InMemoryArticleContentRepository()
    default:
      return AppArticleContentRepository(httpGet: httpGet)
    }
  }

  func makeReadingListContainer() -> ReadingListContainer {
    ReadingListContainer(
      addReadingListItem: readingListRepository,
      listReadingListItem: readingListRepository,
      getArticle: articlesRepository
    )
  }

  private static func makeHttpGet() -> HttpGet {
    RestHttpClient()
  }
}

extension InMemoryArticlesRepository: ArticlesRepository {}
extension InMemoryArticleContentRepository: ArticleContentRepository {}
extension AppArticlesRepository: ArticlesRepository {}
extension AppArticleContentRepository: ArticleContentRepository {}
