import Combine
import Foundation

struct RestHttpClient: HttpGet {}

extension RestHttpClient {
  func get(for url: URL, receiveOn queue: DispatchQueue) -> AnyPublisher<Data, HttpError> {
    URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { element in
        guard let response = element.response as? HTTPURLResponse
        else {
          throw HttpError.serverError
        }
        guard (200 ... 299).contains(response.statusCode) else {
          throw errorFromStatusCode(statusCode: response.statusCode)
        }
        return element.data
      }
      .mapError { _ in
        HttpError.serverError
      }
      .receive(on: queue)
      .eraseToAnyPublisher()
  }

  private func errorFromStatusCode(statusCode: Int) -> HttpError {
    switch statusCode {
    case 404:
      return .notFound
    default:
      return .serverError
    }
  }
}

extension Publisher {
  func nilWhen<Data>(error handleError: HttpError) -> Publishers.TryCatch<Self, AnyPublisher<Data?, HttpError>> {
    tryCatch { error in
      guard let error = error as? HttpError else {
        return Fail<Data?, HttpError>(error: HttpError.serverError).eraseToAnyPublisher()
      }

      if error == handleError {
        return Just(nil).setFailureType(to: HttpError.self).eraseToAnyPublisher()
      } else {
        return Fail(error: error).eraseToAnyPublisher()
      }
    }
  }
}
