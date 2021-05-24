import Combine
import Foundation

struct RestHttpClient: HttpGet {}

extension RestHttpClient {
  func get(for url: URL, receiveOn queue: DispatchQueue) -> AnyPublisher<Data, HttpError> {
    URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .mapError { _ in
        HttpError.serverError
      }
      .receive(on: queue)
      .eraseToAnyPublisher()
  }
}
