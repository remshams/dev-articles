import Foundation

typealias ArticleId = Int

struct Article: Identifiable, Equatable {
  let title: String
  let id: ArticleId
  let description: String
  let link: URL
  var bookmarked: Bool = false
}
