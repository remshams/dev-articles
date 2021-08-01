import Combine
import Foundation

// MARK: Protocols

protocol ArticlesRestAdapter: ListArticle, GetArticle {}

// MARK: Models

struct ArticleRestDto: Identifiable, Codable {
  let id: Int
  let title: String
  let description: String
  let url: String
  // swiftlint:disable identifier_name
  let cover_image: String?
  let published_at: String
  let reading_time_minutes: Int
  let comments_count: Int
  let positive_reactions_count: Int
  let public_reactions_count: Int
  let user: AuthorRestDto
  let tag_list: [String]
  // swiftlint:enable identifier_name
}

// MARK: Extensions

extension ArticleRestDto {
  func toArticle() -> Article {
    Article(
      title: title,
      id: String(id),
      description: description,
      metaData: ArticleMetaData(
        link: URL(string: url)!,
        coverImageUrl: cover_image != nil ? URL(string: cover_image!)! : nil,
        publishedAt: published_at.iso8601Date,
        readingTime: reading_time_minutes
      ),
      communityData: ArticleCommunityData(
        commentsCount: comments_count,
        positiveReactionsCount: positive_reactions_count,
        publicReactionsCount: public_reactions_count
      ),
      author: user.toAuthor(),
      tags: tag_list
    )
  }
}

// MARK: Operators

extension Publisher where Output == [ArticleRestDto] {
  func toArticles() -> Publishers.Map<Self, [Article]> {
    map { articles in articles.map { $0.toArticle() } }
  }
}

extension Publisher where Output == ArticleRestDto {
  func toArticle() -> Publishers.Map<Self, Article?> {
    map { $0.toArticle() }
  }
}
