import Combine
import Foundation

// MARK: Protocols

protocol ArticlesRestAdapter {
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError>
}

// MARK: Models

struct ArticleRestDto: Identifiable, Codable {
  let id: Int
  let title: String
  let description: String
  let url: String
  // swiftlint:disable identifier_name
  let cover_image: String
  let published_timestamp: String
  let reading_time_minutes: Int
  let comments_count: Int
  let positive_reactions_count: Int
  let public_reactions_count: Int
  // swiftlint:enable identifier_name
}

// MARK: Extensions

extension ArticleRestDto {
  func toArticle() -> Article {
    Article(
      title: title,
      id: String(id),
      description: description,
      metaData: MetaData(
        link: URL(string: url)!,
        coverImageUrl: URL(string: cover_image)!,
        publishedAt: published_timestamp.toIso8601Date(),
        readingTime: reading_time_minutes
      ),
      communityData: CommunityData(
        commentsCount: comments_count,
        positiveReactionsCount: positive_reactions_count,
        publicReactionsCount: public_reactions_count
      )
    )
  }
}

// MARK: Operators

extension Publisher where Output == [ArticleRestDto] {
  func toArticles() -> Publishers.Map<Self, [Article]> {
    map { articles in articles.map { $0.toArticle() } }
  }
}
