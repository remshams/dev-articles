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
    collect(stream$: adapter.list$(for: .feed), collect: 1, cancellables: &cancellables)
      .sink(receiveCompletion: { _ in }, receiveValue: { XCTAssertEqual($0, [self.articles]) })
      .store(in: &cancellables)
    
    collect(stream$: client.urlCalledSubject.eraseToAnyPublisher(), collect: 1, cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual($0, [[URL(string: self.articleUrl)!]]) })
      .store(in: &cancellables)
  }

  func test_list$_ShouldEmitListOfArticlesForTimeCategory() -> Void {
    collect(stream$: adapter.list$(for: .week), collect: 1, cancellables: &cancellables)
      .sink(receiveCompletion: { _ in }, receiveValue: { XCTAssertEqual($0, [self.articles]) })
      .store(in: &cancellables)
    
    collect(stream$: client.urlCalledSubject.eraseToAnyPublisher(), collect: 1, cancellables: &cancellables)
      .sink(receiveValue: { XCTAssertEqual($0, [[URL(string: self.articleUrl + "?top=7")!]]) })
      .store(in: &cancellables)
  }
}
