import XCTest
import Combine
@testable import dev_articles

struct TestClient: MockHttpGet {
  let getResponse: [ArticleDto]
  let urlCalledSubject: CurrentValueSubject<[URL], Never>
}

class ArticlesRestAdapterTests: XCTestCase {
  var articleDtos: [ArticleDto]!
  var articles: [Article]!
  let urlCalled$ = CurrentValueSubject<[URL], Never>([])
  let articleUrl = devCommunityUrl + articlesPath
  var client: TestClient!
  var adapter: ArticlesRestAdapter!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    articleDtos = createArticleDtoListFixture(min: 2)
    client = TestClient(getResponse: articleDtos, urlCalledSubject: urlCalled$)
    adapter = ArticlesRestAdapter(httpGet: client)
    articles = articleDtos.map(convertToArticle)
    cancellables = []
  }
  
  override func tearDown() {
    cancellables = []
  }
  
  func test_list$_ShouldEmitListOfArticlesForFeed() -> Void {
    assertStreamEquals(cancellables: &cancellables, received$: adapter.list$(for: .feed), expected: articles)
    assertStreamEquals(cancellables: &cancellables, received$: client.urlCalledSubject.eraseToAnyPublisher(), expected: [URL(string: articleUrl)!])
  }

  func test_list$_ShouldEmitListOfArticlesForTimeCategory() -> Void {
    assertStreamEquals(cancellables: &cancellables, received$: adapter.list$(for: .week), expected: articles)
    assertStreamEquals(cancellables: &cancellables, received$: client.urlCalledSubject.eraseToAnyPublisher(), expected: [URL(string: articleUrl + "?top=7")!])
  }
}
