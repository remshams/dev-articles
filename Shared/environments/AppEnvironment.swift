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
  let listReadingListItem: ListReadingListItem
  
  init(addReadingListItem: AddReadingListItem, listReadingListItem: ListReadingListItem) {
    self.addReadingListItem = addReadingListItem
    self.listReadingListItem = listReadingListItem
  }
  
}

