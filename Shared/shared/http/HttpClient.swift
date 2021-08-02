import Combine
import Foundation
import OSLog

protocol HttpGet {
  func get(for url: URL, receiveOn queue: DispatchQueue) -> AnyPublisher<Data, HttpError>
}

extension HttpGet {
  func get(for url: URL) -> AnyPublisher<Data, HttpError> {
    get(for: url, receiveOn: DispatchQueue.main)
  }
}

extension Publisher where Output == Data {
  func decode<Model: Decodable>(
    to type: Model.Type = Model.self,
    decoder: JSONDecoder = .init()
  ) -> AnyPublisher<Model, HttpError> {
    decode(type: type, decoder: decoder)
      .logAndMapDecodingError()
      .eraseToAnyPublisher()
  }
}

extension Publisher {
  func logAndMapDecodingError() -> Publishers.MapError<Self, HttpError> {
    mapError { error in
      if let error = error as? DecodingError {
        switch error {
        case let .keyNotFound(key, context):
          Logger().debug("\(key.stringValue) not found: \(context.debugDescription)")
        case let .typeMismatch(_, context):
          Logger().debug("\(context.codingPath) not matching: \(context.debugDescription)")
        case let .valueNotFound(_, context):
          Logger().debug("\(context.codingPath) not found: \(context.debugDescription)")
        case let .dataCorrupted(context):
          Logger().debug("Invalid data: \(context.debugDescription)")
        default:
          Logger().debug("Decoding error")
        }
      }
      if let error = error as? HttpError {
        return error
      } else {
        return .serverError
      }
    }
  }
}
