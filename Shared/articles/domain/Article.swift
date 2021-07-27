import Combine
import Foundation

typealias ArticleId = String

enum TimeCategory: Int {
  case day = 1
  case week = 7
  case month = 30
  case year = 356
}

protocol ListArticle {
  func list(for timeCategory: TimeCategory, page: Int, pageSize: Int) -> AnyPublisher<[Article], RepositoryError>
  func getBy(path: String) -> AnyPublisher<Article?, RepositoryError>
}

protocol ListArticleContent {
  func content(for id: ArticleId) -> AnyPublisher<ArticleContent, RepositoryError>
}

// MARK: Models

struct Article: Identifiable, Equatable {
  let title: String
  let id: ArticleId
  let description: String
  let metaData: ArticleMetaData
  let communityData: ArticleCommunityData
  let author: Author
  let tags: [String]
  var bookmarked: Bool = false
}

struct ArticleMetaData: Equatable {
  let link: URL
  let coverImageUrl: URL?
  let publishedAt: Date?
  let readingTime: Int
}

struct ArticleCommunityData: Equatable {
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
    title: "Article for Preview with some long text",
    id: "0",
    description: "Article for Preview",
    metaData: ArticleMetaData(
      link: URL(string: "https://www.dev.to")!,
      coverImageUrl: nil,
      publishedAt: Date(),
      readingTime: 12
    ),
    communityData: ArticleCommunityData(commentsCount: 4, positiveReactionsCount: 18, publicReactionsCount: 18),
    author: authorForPreview,
    tags: ["Swift", "SwiftUI"]
  )
#endif
