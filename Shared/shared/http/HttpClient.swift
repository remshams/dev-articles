import Foundation
import Combine

let devCommunityUrl = "https://dev.to/api"

protocol HttpGet {
  func get(for url: URL) -> AnyPublisher<Data, HttpError>
}

extension HttpGet {
  func get(for url: URL) -> AnyPublisher<Data, HttpError> {
    URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .mapError() { error in
        HttpError.serverError
      }
      .eraseToAnyPublisher()
  }
}


