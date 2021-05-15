import Combine
@testable import dev_articles
import Foundation

protocol MockHttpGet: HttpGet {
  associatedtype Dto: Codable

  var getResponse: Dto { get }
  var urlCalledSubject: CurrentValueSubject<[URL], Never> { get }
}

extension MockHttpGet {
  func get(for url: URL) -> AnyPublisher<Data, HttpError> {
    urlCalledSubject.send(urlCalledSubject.value + [url])
    return Just(getResponse)
      .encode(encoder: JSONEncoder())
      .mapError { _ in HttpError.serverError }
      .eraseToAnyPublisher()
  }
}
