import Combine
@testable import dev_articles
import Foundation

struct MockHttpGet<Dto: Codable> {
  let getResponse: Dto
  let urlCalledSubject: CurrentValueSubject<[URL], Never>
}

extension MockHttpGet: HttpGet {
  func get(for url: URL, receiveOn _: DispatchQueue) -> AnyPublisher<Data, HttpError> {
    urlCalledSubject.send(urlCalledSubject.value + [url])
    return Just(getResponse)
      .encode(encoder: JSONEncoder())
      .mapError { _ in HttpError.serverError }
      .eraseToAnyPublisher()
  }
}
