import Combine
import CoreData
import Foundation

protocol ArticlesRepository: ListArticle, GetArticle {}
protocol ArticleContentRepository: ListArticleContent {}

struct AppContainer {
  static let shared = AppContainer()

  let persistence: PersistenceController
  private let httpGet: HttpGet
  private let articlesRepository: ArticlesRepository
  private let articleContentRepository: ArticleContentRepository

  init() {
    persistence = AppContainer.makePersistence()
    httpGet = AppContainer.makeHttpGet()
    articlesRepository = AppContainer.makeArticlesRepository(httpGet: httpGet)
    articleContentRepository = AppContainer.makeArticleContentRepository(httpGet: httpGet)
    print("Running with configuration: \(configuration)")
  }

  func makeArticlesContainer() -> ArticlesContainer {
    ArticlesContainer(
      listArticle: articlesRepository,
      getArticle: articlesRepository,
      listArticleContent: articleContentRepository
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

  private static func makePersistence() -> PersistenceController {
    switch configuration {
    case .release:
      return PersistenceController(inMemory: false)
    default:
      return PersistenceController(inMemory: true)
    }
  }

  func makeReadingListContainer() -> ReadingListContainer {
    ReadingListContainer(
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
