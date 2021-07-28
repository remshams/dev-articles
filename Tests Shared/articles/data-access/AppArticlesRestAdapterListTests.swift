import Combine
@testable import dev_articles
import XCTest

class AppArticlesRestAdapterListTests: XCTestCase {
  var articleDtos: [ArticleRestDto]!
  var articles: [Article]!
  let urlCalled = CurrentValueSubject<[URL], Never>([])
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
    var articlesUrlComponents = URLComponents(string: articlesUrl)!
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
}
