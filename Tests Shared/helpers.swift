import Foundation
import XCTest
import Combine

extension XCTestCase {
  func assertStreamEquals<Output: Equatable, Failure: Error>(
    cancellables: inout Set<AnyCancellable>,
    received$: AnyPublisher<Output, Failure>,
    expected: Output
  ) -> Void {
    let exp = expectation(description: #function)
    var result: Output? = nil
    
    received$.sink(receiveCompletion: { _ in  }, receiveValue: { received in
      
      result = received
      print(received)
      exp.fulfill()
    }).store(in: &cancellables)
    
    waitForExpectations(timeout: 2)
    
    if let result = result {
      XCTAssertEqual(result, expected)
    } else {
      XCTFail("Test did not run")
    }
    
  }
}
