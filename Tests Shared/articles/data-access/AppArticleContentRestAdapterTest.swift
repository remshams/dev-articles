//
//  AppArticleContentRestAdapterTest.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 04.07.21.
//

import Combine
@testable import dev_articles
import Foundation
import XCTest

class AppArticleContentRestAdapterTest: XCTestCase {
  var httpGet: MockHttpGet<ArticleContentRestDto>!
  var articleContentDto: ArticleContentRestDto!
  var restAdapter: AppArticleContentRestAdapter!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    articleContentDto = ArticleContentRestDto.createFixture()
    httpGet = MockHttpGet(getResponse: articleContentDto)
    restAdapter = AppArticleContentRestAdapter(httpGet: httpGet)
    cancellables = []
  }

  func test_content_shouldReturnConvertedArticleContent() {
    restAdapter.content(for: "0")
      .sink(receiveCompletion: { _ in }, receiveValue: { XCTAssertEqual($0, self.articleContentDto.toArticleContent()) })
      .store(in: &cancellables)
  }
}
