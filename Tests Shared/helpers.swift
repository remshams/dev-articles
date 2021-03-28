import Foundation
import XCTest
import Combine

extension XCTestCase {
  func assertStreamEquals<Output: Equatable, Failure: Error>(
    cancellables: inout Set<AnyCancellable>,
    received$: AnyPublisher<Output, Failure>,
    expected: [Output],
    with assert: ([Output], [Output]) -> Void = { XCTAssertEqual($0, $1) }
  ) -> Void {
    let exp = expectation(description: #function)
    var result: [Output] = []
    
    received$.sink(receiveCompletion: { _ in  }, receiveValue: { received in
      result += [received]
      
      if (result.count == expected.count) {
        exp.fulfill()
      }
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 2)
    
    assert(result, expected)
  }
}
