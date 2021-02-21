//
//  ProductionArticlesRestAdapter.swift
//  SharedTests
//
//  Created by Mathias Remshardt on 07.02.21.
//

import XCTest
import Combine
@testable import dev_articles

class ArticlesRestAdapterTests: XCTestCase {
  var adapter: ArticlesRestAdapter!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    adapter = ArticlesRestAdapter()
    cancellables = []
  }
  
  override func tearDown() {
    cancellables = []
  }
  
  func test_list$_ShouldEmitListOfArticles() -> Void {
    let exp = expectation(description: "List emitted")
    
    adapter.list$().sink(receiveCompletion: { _ in exp.fulfill() }, receiveValue: { articles in
      
      XCTAssertNotNil(articles)
      XCTAssertGreaterThan(articles.count, 0)
      
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 1, handler: nil)
    
  }
}
