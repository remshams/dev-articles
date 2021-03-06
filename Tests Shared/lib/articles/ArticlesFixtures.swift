import Foundation
@testable import dev_articles

func createArticleFixture(title: String = "title", description: String = "description", id: Int = 0, published: Bool = false) -> Article {
  Article(title: title, id: id, description: description, link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!)
}

func createArticlesListFixture(min: Int = 0, max: Int = 12) -> [Article] {
  (0...Int.random(in: min...max)).map({createArticleFixture(id: $0)})
}
