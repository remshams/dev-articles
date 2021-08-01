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
  let tags: String

  init(
    id: Int,
    title: String,
    description: String,
    url: String,
    cover_image: String?,
    published_at: String,
    reading_time_minutes: Int,
    comments_count: Int,
    positive_reactions_count: Int,
    public_reactions_count: Int,
    user: AuthorRestDto,
    tag_list: [String]
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.url = url
    self.cover_image = cover_image
    self.published_at = published_at
    self.reading_time_minutes = reading_time_minutes
    self.comments_count = comments_count
    self.positive_reactions_count = positive_reactions_count
    self.public_reactions_count = public_reactions_count
    self.user = user
    self.tag_list = tag_list
    self.tags = tag_list.joined(separator: ",")
  }

  // swiftlint:enable identifier_name

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ArticleRestDto.CodingKeys.self)

    id = try container.decode(Int.self, forKey: ArticleRestDto.CodingKeys.id)
    title = try container.decode(String.self, forKey: ArticleRestDto.CodingKeys.title)
    description = try container.decode(String.self, forKey: ArticleRestDto.CodingKeys.description)
    url = try container.decode(String.self, forKey: ArticleRestDto.CodingKeys.url)
    cover_image = try container.decode(String?.self, forKey: ArticleRestDto.CodingKeys.cover_image)
    published_at = try container.decode(String.self, forKey: ArticleRestDto.CodingKeys.published_at)
    reading_time_minutes = try container.decode(Int.self, forKey: ArticleRestDto.CodingKeys.reading_time_minutes)
    comments_count = try container.decode(Int.self, forKey: ArticleRestDto.CodingKeys.comments_count)
    positive_reactions_count = try container.decode(
      Int.self,
      forKey: ArticleRestDto.CodingKeys.positive_reactions_count
    )
    public_reactions_count = try container.decode(Int.self, forKey: ArticleRestDto.CodingKeys.public_reactions_count)
    user = try container.decode(AuthorRestDto.self, forKey: ArticleRestDto.CodingKeys.user)
    // Workaround for issue https://github.com/forem/forem/issues/14396
    // "tags" and "tag_list" types can be switched so therefor in case decoding of "tag_list" fails "tags" is tried.
    // In case this fails as well the "tag_list" is set to an empty array.
    do {
      tag_list = try container.decode([String].self, forKey: ArticleRestDto.CodingKeys.tag_list)
      tags = tag_list.joined(separator: ",")
    } catch {
      do {
        tag_list = try container.decode([String].self, forKey: ArticleRestDto.CodingKeys.tags)
        tags = tag_list.joined(separator: ",")
      } catch {
        tag_list = []
        tags = ""
      }
    }
  }
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
