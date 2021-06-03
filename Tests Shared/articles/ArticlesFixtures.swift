@testable import dev_articles
import Foundation

extension MetaData {
  static func createFixture(
    link: URL = URL(string: "https://www.dev.to")!,
    coverImage: URL = URL(string: "https://www.dev.to")!,
    publishedTimeStamp: Date = Date(), readingTimeMinutes: Int = 12
  ) -> MetaData {
    MetaData(link: link, coverImageUrl: coverImage, publishedAt: publishedTimeStamp, readingTime: readingTimeMinutes)
  }
}

extension CommunityData {
  static func createFixture(
    commentsCount: Int = 12,
    positiveReactionsCount: Int = 12,
    publicReactionsCount: Int = 12
  ) -> CommunityData {
    CommunityData(
      commentsCount: commentsCount,
      positiveReactionsCount: positiveReactionsCount,
      publicReactionsCount: publicReactionsCount
    )
  }
}

extension Article {
  static func createFixture(
    id: String = "0",
    title: String = "title",
    description: String = "description",
    metaData: MetaData = MetaData.createFixture(),
    communityData: CommunityData = CommunityData.createFixture(),
    bookmarked _: Bool = false
  ) -> Article {
    Article(
      title: title,
      id: id,
      description: description,
      metaData: metaData,
      communityData: communityData,
      bookmarked: false
    )
  }

  static func createListFixture(min: Int = 0, max: Int = 12) -> [Article] {
    (0 ... Int.random(in: min ... max)).map { Article.createFixture(id: String($0)) }
  }
}
