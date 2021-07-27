import Combine
@testable import dev_articles
import XCTest

class AppArticlesRestAdapterTests: XCTestCase {
  var articleDtos: [ArticleRestDto]!
  var articles: [Article]!
  let urlCalled = CurrentValueSubject<[URL], Never>([])
  let articleUrl = devCommunityUrl + articlesPath
  let page = 1
  let pageSize = 10
  var client: MockHttpGet<[ArticleRestDto]>!
  var adapter: AppArticlesRestAdapter!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    articleDtos = ArticleRestDto.createListFixture(min: 2)
    client = MockHttpGet(getResponse: articleDtos, urlCalledSubject: urlCalled)
    adapter = AppArticlesRestAdapter(httpGet: client)
    articles = articleDtos.map { $0.toArticle() }
    cancellables = []
  }

  override func tearDown() {
    cancellables = []
  }

  func test_list_ShouldEmitListOfArticlesForTimeCategory() {
    var articlesUrlComponents = URLComponents(string: articleUrl)!
    articlesUrlComponents.queryItems = [
      URLQueryItem(name: ArticleQueryParam.timeCategory.rawValue, value: String(TimeCategory.week.rawValue)),
      URLQueryItem(name: ArticleQueryParam.page.rawValue, value: String(page)),
      URLQueryItem(name: ArticleQueryParam.pageSize.rawValue, value: String(pageSize))
    ]

    adapter.list(for: .week, page: 1, pageSize: 10)
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, self.articles)
      }
      .store(in: &cancellables)

    client.urlCalledSubject
      .sink { _ in } receiveValue: {
        XCTAssertEqual(
          $0,
          [
            articlesUrlComponents.url!
          ]
        )
      }
      .store(in: &cancellables)
  }

  func test_getBy_returnsArticle() {
    let path = "first/second"
    let clientSingleReturn = MockHttpGet(getResponse: articleDtos.first!, urlCalledSubject: urlCalled)
    adapter = AppArticlesRestAdapter(httpGet: clientSingleReturn)
    let articleCompoenents = URLComponents(string: articleUrl + path)!

    adapter.getBy(path: path)
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, self.articles.first!)
      }
      .store(in: &cancellables)

    clientSingleReturn.urlCalledSubject
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, [articleCompoenents.url!])
      }
      .store(in: &cancellables)
  }

  func test_getBy_returnsNilInCaseArticleCannotBeFound() {
    let path = "first/second"
    let clientNilReturn = MockHttpGet<ArticleRestDto?>(getResponse: nil, urlCalledSubject: urlCalled)
    adapter = AppArticlesRestAdapter(httpGet: clientNilReturn)

    adapter.getBy(path: path)
      .sink { _ in } receiveValue: {
        XCTAssertNil($0)
      }
      .store(in: &cancellables)
  }

  func test_getBy_ignoresSlashAtTheBeginning() {
    let path = "/first/second"
    let clientSingleReturn = MockHttpGet(getResponse: articleDtos.first!, urlCalledSubject: urlCalled)
    adapter = AppArticlesRestAdapter(httpGet: clientSingleReturn)
    let articleCompoenents = URLComponents(string: articleUrl + path)!

    adapter.getBy(path: path)
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, self.articles.first!)
      }
      .store(in: &cancellables)

    clientSingleReturn.urlCalledSubject
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, [articleCompoenents.url!])
      }
      .store(in: &cancellables)
  }
}
