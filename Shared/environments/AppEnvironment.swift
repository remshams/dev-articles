import Foundation
import Combine

class ArticlesEnvironment: ObservableObject {
  let listArticle: ListArticle
  
  init(listArticle: ListArticle) {
    self.listArticle = listArticle
  }
}

