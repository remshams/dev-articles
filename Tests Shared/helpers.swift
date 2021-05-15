import Combine
import Foundation
import XCTest

extension XCTestCase {
  func assertStreamEquals<Output: Equatable, Failure: Error>(
    cancellables: inout Set<AnyCancellable>,
    received$: AnyPublisher<Output, Failure>,
    expected: [Output],
    with assert: ([Output], [Output]) -> Void = { XCTAssertEqual($0, $1) }
  ) -> Void {
    let exp = expectation(description: #function)
    var result: [Output] = []

    received$.sink(receiveCompletion: { _ in }, receiveValue: { received in
      result += [received]

      if result.count == expected.count {
        exp.fulfill()
      }
    }).store(in: &cancellables)

    waitForExpectations(timeout: 2)

    assert(expected, result)
  }

  func collect<Output, Failure: Error>(
    stream$: AnyPublisher<Output, Failure>,
    collect count: Int = 1,
    cancellables: inout Set<AnyCancellable>
  ) -> AnyPublisher<[Output], Failure> {
    let exp = expectation(description: #function)
    let result = CurrentValueSubject<[Output], Failure>([])

    stream$
      .prefix(count)
      .collect(count)
      .sink(receiveCompletion: { _ in exp.fulfill() }, receiveValue: result.send)
      .store(in: &cancellables)

    waitForExpectations(timeout: 2)

    return result.eraseToAnyPublisher()
  }

  func waitFor<Output, Failure: Error>(
    stream$: AnyPublisher<Output, Failure>,
    waitFor count: Int,
    cancellables: inout Set<AnyCancellable>
  ) -> Void {
    let exp = expectation(description: #function)

    stream$
      .prefix(count)
      .sink(receiveCompletion: { _ in exp.fulfill() }, receiveValue: { _ in })
      .store(in: &cancellables)

    waitForExpectations(timeout: 2)
  }
}
