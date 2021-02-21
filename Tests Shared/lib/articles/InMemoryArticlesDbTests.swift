import Foundation
import XCTest
import Combine
@testable import dev_articles

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
    let exp = expectation(description: #function)
    db.list$().sink(
      receiveCompletion: { _ in
        exp.fulfill()
      },
      receiveValue: { self.result.append(contentsOf: $0) }
    ).store(in: &cancellables)
    
    XCTAssertEqual(result, [])
    
    waitForExpectations(timeout: 2)
  }
  
  func test_list$_ShoudEmitArticlesWhenInitalizedWithList() -> Void {
    let exp = expectation(description: #function)
    db = InMemoryArticlesDb(articles: articles)
    
    db.list$().sink(
      receiveCompletion: { _ in
        exp.fulfill()
      },
      receiveValue: { self.result.append(contentsOf: $0) }
    ).store(in: &cancellables)
    
    result.sort(by: { $0.id <= $1.id })
    XCTAssertEqual(result, articles)
    
    waitForExpectations(timeout: 2)
  }
  
  func test_list$_ShouldEmitArticlesWhenInitializedWithDictionary() -> Void {
    let exp = expectation(description: #function)
    db = InMemoryArticlesDb(articlesById: articles.toDictionaryById())
    
    db.list$().sink(
      receiveCompletion: { _ in
        exp.fulfill()
      },
      receiveValue: { self.result.append(contentsOf: $0) }
    ).store(in: &cancellables)
    
    result.sort(by: { $0.id <= $1.id })
    XCTAssertEqual(result, articles)
    
    waitForExpectations(timeout: 2)
  }
  
  func test_add_ShouldEmitAddNewArticle() -> Void {
    let exp = expectation(description: #function);
    db = InMemoryArticlesDb();
    db.add(article: articles[0])
    
    db.list$().sink(
      receiveCompletion: { _ in exp.fulfill() },
      receiveValue: { self.result.append(contentsOf: $0) }
    ).store(in: &cancellables)
    
    XCTAssertEqual(result, [articles.first])
    
    waitForExpectations(timeout: 2)
  }
  
}
