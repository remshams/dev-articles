//
//  ProductionArticlesRestAdapter.swift
//  SharedTests
//
//  Created by Mathias Remshardt on 07.02.21.
//

import XCTest
import Combine
@testable import dev_articles

class TestsProductionArticlesRestAdapter: XCTestCase {
  var adapter: ArticlesRestAdapter!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    adapter = ArticlesRestAdapter()
    cancellables = []
  }
  
  func testListArticlesShouldEmitListOfArticles() throws {
    let exp = expectation(description: "List emitted")
    
    adapter.list$().sink(receiveCompletion: { print($0) }, receiveValue: { articles in
      
      XCTAssertNotNil(articles)
      XCTAssertGreaterThan(articles.count, 0)
      
      exp.fulfill()
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 1, handler: nil)
    
  }
}
