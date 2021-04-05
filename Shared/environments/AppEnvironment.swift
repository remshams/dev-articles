import Foundation
import Combine

class ArticlesEnvironment: ObservableObject {
  let listArticle: ListArticle
  
  init(listArticle: ListArticle) {
    self.listArticle = listArticle
  }
}

class ReadingListEnvironment: ObservableObject {
  let addReadingListItem: AddReadingListItem
  
  init(addReadingListItem: AddReadingListItem) {
    self.addReadingListItem = addReadingListItem
  }
  
}

