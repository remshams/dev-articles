import Combine
import Foundation

protocol HttpGet {
  func get(for url: URL, receiveOn queue: DispatchQueue) -> AnyPublisher<Data, HttpError>
}

extension HttpGet {
  func get(for url: URL) -> AnyPublisher<Data, HttpError> {
    get(for: url, receiveOn: DispatchQueue.main)
  }
}
