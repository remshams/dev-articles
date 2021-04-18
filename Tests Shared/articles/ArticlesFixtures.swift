import Foundation
@testable import dev_articles

func createArticleFixture(title: String = "title", description: String = "description", id: String = "0", link: URL = URL(string: "https://www.apple.de")! ) -> Article {
  Article(title: title, id: id, description: description, link: link)
}

func createArticlesListFixture(min: Int = 0, max: Int = 12) -> [Article] {
  (0...Int.random(in: min...max)).map({createArticleFixture(id: String($0))})
}

func createArticleDtoFixture(title: String = "title", description: String = "description", id: Int = 0, url: String = "https://www.apple.de") -> ArticleDto {
  ArticleDto(id: id, title: title, description: description, url: url)
}

func createArticleDtoListFixture(min: Int = 0, max: Int = 12) -> [ArticleDto] {
  (0...Int.random(in: min...max)).map {createArticleDtoFixture(id: $0)}
}
