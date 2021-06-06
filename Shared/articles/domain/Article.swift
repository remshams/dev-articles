import Combine
import Foundation

typealias ArticleId = String

enum TimeCategory {
  case feed
  case day
  case week
  case month
  case year
}

protocol ListArticle {
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError>
}

// MARK: Models

struct Article: Identifiable, Equatable {
  let title: String
  let id: ArticleId
  let description: String
  let metaData: MetaData
  let communityData: CommunityData
  var bookmarked: Bool = false
}

struct MetaData: Equatable {
  let link: URL
  let coverImageUrl: URL?
  let publishedAt: Date?
  let readingTime: Int
}

struct CommunityData: Equatable {
  let commentsCount: Int
  let positiveReactionsCount: Int
  let publicReactionsCount: Int
}

extension Collection where Element == Article {
  func bookmark(articles: [Article]) -> [Article] {
    map { oldArticle in
      var newArticle = oldArticle
      if articles.contains(oldArticle) {
        newArticle.bookmarked.toggle()
      }
      return newArticle
    }
  }
}

// MARK: Preview Fixtures

#if DEBUG

  let articleForPreview = Article(
    title: "Article for Preview",
    id: "0",
    description: "Article for Preview",
    metaData: MetaData(
      link: URL(string: "https://www.dev.to")!,
      coverImageUrl: nil,
      publishedAt: Date(),
      readingTime: 12
    ),
    communityData: CommunityData(commentsCount: 12, positiveReactionsCount: 18, publicReactionsCount: 18)
  )
#endif
