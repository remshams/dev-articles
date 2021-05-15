import Combine
import Foundation

let devCommunityUrl = "https://dev.to/api"

protocol HttpGet {
  func get(for url: URL) -> AnyPublisher<Data, HttpError>
}
