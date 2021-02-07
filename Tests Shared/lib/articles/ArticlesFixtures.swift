import Foundation
@testable import dev_articles

func createArticleFixture(title: String = "title", description: String = "description", id: Int = 0, published: Bool = false) -> Article {
  Article(title: title, id: id, description: description, published: published)
}

func createArticlesListFixture(min: Int = 0, max: Int = 12) -> [Article] {
  (min...max).map({_ in createArticleFixture()})
}
