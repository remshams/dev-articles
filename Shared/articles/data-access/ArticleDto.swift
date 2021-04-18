import Foundation

struct ArticleDto: Identifiable, Codable {
  let id: Int
  let title: String
  let description: String
  let url: String
}

func convertToArticle(articleDto: ArticleDto) -> Article {
  Article(title: articleDto.title, id: String(articleDto.id), description: articleDto.description, link: URL(string: articleDto.url)!)
}
