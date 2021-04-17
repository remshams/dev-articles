import Foundation
import Combine

let devCommunityUrl = "https://dev.to/api"

protocol HttpGet {
  func get(for url: URL) -> AnyPublisher<Data, RestError>
}

extension HttpGet {
  func get(for url: URL) -> AnyPublisher<Data, RestError> {
    URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .mapError() { error in
        RestError.serverError
      }
      .eraseToAnyPublisher()
  }
}


