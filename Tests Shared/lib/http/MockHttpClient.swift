import Foundation
import Combine
@testable import dev_articles


protocol MockHttpGet: HttpGet {
  associatedtype Dto: Codable
  
  var getResponse: Dto { get }
  var urlCalledSubject: CurrentValueSubject<[URL], Never> { get }

}

extension MockHttpGet {
  
  func get(for url: URL) -> AnyPublisher<Data, RestError> {
    urlCalledSubject.send(urlCalledSubject.value + [url])
    return Just(getResponse)
      .encode(encoder: JSONEncoder())
      .mapError() { error in RestError.serverError }
      .eraseToAnyPublisher()
  }
}
