//
//  HttpClientTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 02.08.21.
//

import Combine
@testable import dev_articles
import Foundation
import XCTest

class HttpClientTests: XCTestCase {
  enum TestError: Error {
    case error
  }

  let httpError = HttpError.notFound
  let otherError = TestError.error
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    cancellables = []
  }

  func tests_logDecodingError_shouldPassThroughHttpError() {
    Fail<String, HttpError>(error: httpError).logAndMapDecodingError()
      .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(error): XCTAssertEqual(error, self.httpError)
        case .finished: XCTFail("Should not complete")
        }
      }, receiveValue: { _ in XCTFail("should not emit value") })
      .store(in: &cancellables)
  }

  func tests_logDecodingError_shouldMapOtherErrorsToHttpServerError() {
    Fail<String, TestError>(error: otherError).logAndMapDecodingError()
      .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(error): XCTAssertEqual(error, .serverError)
        case .finished: XCTFail("Should not complete")
        }
      }, receiveValue: { _ in XCTFail("should not emit value") })
      .store(in: &cancellables)
  }
}
