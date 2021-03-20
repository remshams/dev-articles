import Foundation
import XCTest
import Combine
@testable import dev_articles

extension Article: Comparable {
  public static func < (lhs: Article, rhs: Article) -> Bool {
    lhs.id < rhs.id
  }
  
  
  
}

class InMemoryArticlesDbTests: XCTestCase {
  
  let articles = createArticlesListFixture(min: 2)
  var result: [Article]!
  var cancellables: Set<AnyCancellable>!;
  var db: InMemoryArticlesDb!
  
  override func setUp() {
    db = InMemoryArticlesDb()
    cancellables = [];
    result = []
  }
  
  override func tearDown() {
    cancellables = []
    result = []
  }
  
  func test_list$_ShouldEmitNothingWhenNoArticleHasBeenStored() -> Void {
    assertStreamEquals(cancellables: &cancellables, received$: db.list$(for: .feed), expected: [[]])
    
  }
  
  func test_list$_ShoudEmitArticlesWhenInitalizedWithList() -> Void {
    db = InMemoryArticlesDb(articles: articles)
    
    assertStreamEquals(
      cancellables: &cancellables,
      received$: db.list$(for: .feed).map({$0.sorted()}).eraseToAnyPublisher(),
      expected: [articles]
    )
    
  }
  
  func test_list$_ShouldEmitArticlesWhenInitializedWithDictionary() -> Void {
    db = InMemoryArticlesDb(articlesById: articles.toDictionaryById())
    
    assertStreamEquals(
      cancellables: &cancellables,
      received$: db.list$(for: .feed).map({$0.sorted()}).eraseToAnyPublisher(),
      expected: [articles]
    )
    
  }
  
  func test_add_ShouldEmitNewlyAddedArticle() -> Void {
    db = InMemoryArticlesDb();
    db.add(article: articles.first!)
    
    assertStreamEquals(cancellables: &cancellables, received$: db.list$(for: .feed), expected: [[articles.first!]])
  }
  
}
