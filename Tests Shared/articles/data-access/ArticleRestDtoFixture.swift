//
//  ArticleRestDtoFixture.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 03.06.21.
//

@testable import dev_articles
import Foundation

extension ArticleRestDto {
  static func createFixture(
    id: Int = 0,
    title: String = "title",
    description: String = "description",
    url: String = "https://www.dev.to",
    coverImage: String = "https://www.dev.to",
    publishedTimeStamp: String = "2021-05-29T07:50:42Z",
    readingTimeMinutes: Int = 12,
    commentsCount: Int = 12,
    positiveReactionsCount: Int = 12,
    publicReactionsCount: Int = 12

  ) -> ArticleRestDto {
    ArticleRestDto(
      id: id,
      title: title,
      description: description,
      url: url,
      cover_image: coverImage,
      published_at: publishedTimeStamp,
      reading_time_minutes: readingTimeMinutes,
      comments_count: commentsCount,
      positive_reactions_count: positiveReactionsCount,
      public_reactions_count: publicReactionsCount,
      user: AuthorRestDto.createFixture(),
      tag_list: ["Swift", "SwiftUI"]
    )
  }

  static func createListFixture(min: Int = 0, max: Int = 12) -> [ArticleRestDto] {
    (0 ... Int.random(in: min ... max)).map { ArticleRestDto.createFixture(id: $0) }
  }
}
