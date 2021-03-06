import Foundation

struct Article: Identifiable, Equatable {
  let title: String
  let id: Int
  let description: String
  let link: URL
}
