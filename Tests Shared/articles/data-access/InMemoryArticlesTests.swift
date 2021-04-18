import Foundation
import XCTest
import Combine
@testable import dev_articles

extension Article: Comparable {
  public static func < (lhs: Article, rhs: Article) -> Bool {
    lhs.id < rhs.id
  }
  
  
  
}

class InMemoryArticlesRepositoryTests: XCTestCase {
  
  let articles = createArticlesListFixture(min: 2)
  var result: [Article]!
  var cancellables: Set<AnyCancellable>!;
  var db: InMemoryArticlesRepository!
  
  override func setUp() {
    db = InMemoryArticlesRepository()
    cancellables = [];
    result = []
  }
  
  override func tearDown() {
    cancellables = []
    result = []
  }
  
  func test_list_ShouldEmitNothingWhenNoArticleHasBeenStored() -> Void {
    assertStreamEquals(cancellables: &cancellables, received$: db.list(for: .feed), expected: [[]])
    
  }
  
  func test_list_ShoudEmitArticlesWhenInitalizedWithList() -> Void {
    db = InMemoryArticlesRepository(articles: articles)
    
    assertStreamEquals(
      cancellables: &cancellables,
      received$: db.list(for: .feed).map({$0.sorted()}).eraseToAnyPublisher(),
      expected: [articles]
    )
    
  }
  
  func test_list_ShouldEmitArticlesWhenInitializedWithDictionary() -> Void {
    db = InMemoryArticlesRepository(articlesById: articles.toDictionaryById())
    
    assertStreamEquals(
      cancellables: &cancellables,
      received$: db.list(for: .feed).map({$0.sorted()}).eraseToAnyPublisher(),
      expected: [articles]
    )
    
  }
  
  func test_add_ShouldEmitNewlyAddedArticle() -> Void {
    db = InMemoryArticlesRepository();
    let addedArticle = articles.first!
    collect(stream$: db.add(entity: addedArticle), collect: 1, cancellables: &cancellables)
      .sink(receiveCompletion: { _ in }, receiveValue: {
              XCTAssertEqual($0, [addedArticle])
      })
      .store(in: &cancellables)
    
    assertStreamEquals(cancellables: &cancellables, received$: db.list(for: .feed), expected: [[articles.first!]])
  }
  
}
