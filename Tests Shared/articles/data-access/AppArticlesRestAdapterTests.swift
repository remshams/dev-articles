import Combine
@testable import dev_articles
import XCTest

class AppArticlesRestAdapterTests: XCTestCase {
  var articleDtos: [ArticleRestDto]!
  var articles: [Article]!
  let urlCalled = CurrentValueSubject<[URL], Never>([])
  let articleUrl = devCommunityUrl + articlesPath
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

  func test_list_ShouldEmitListOfArticlesForFeed() {
    adapter.list(for: .feed)
      .sink(receiveCompletion: { _ in }, receiveValue: { XCTAssertEqual($0, self.articles) })
      .store(in: &cancellables)

    client.urlCalledSubject
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, [URL(string: self.articleUrl)!])
      }
      .store(in: &cancellables)
  }

  func test_list_ShouldEmitListOfArticlesForTimeCategory() {
    adapter.list(for: .week)
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, self.articles)
      }
      .store(in: &cancellables)

    client.urlCalledSubject
      .sink { _ in } receiveValue: {
        XCTAssertEqual($0, [URL(string: self.articleUrl + "?top=7")!])
      }
      .store(in: &cancellables)
  }
}
