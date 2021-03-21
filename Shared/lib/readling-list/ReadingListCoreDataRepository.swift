//
//  ReadingListRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 21.03.21.
//

import Foundation
import CoreData

class ReadingListCoreDataRepository: AddReadingListItem, ListReadingListItem  {
  private let managedObjectContext: NSManagedObjectContext
  
  init(managedObjectContext: NSManagedObjectContext) {
    self.managedObjectContext = managedObjectContext
  }
  
  
  func addFrom(article: Article) -> Void {
    let readingListItem = ReadingListItemDbDto(context: managedObjectContext)
    readingListItem.articleId = Int16(article.id)
    readingListItem.title = article.title
    readingListItem.link = article.link
    readingListItem.savedAt = Date()
    do {
      try managedObjectContext.save()
    } catch {
      fatalError("Error saving readingListItem")
    }
  }
  
  func list() -> [ReadlingListItem] {
    let fetchRequest = NSFetchRequest<ReadingListItemDbDto>(entityName: "ReadingListItem")
    do {
      let readingListItems = try managedObjectContext.fetch(fetchRequest)
      return readingListItems.map({ReadlingListItem(articleId: Int($0.articleId), title: $0.title, link: $0.link, saveAt: $0.savedAt)})
    } catch {
      fatalError("Error feting ReadingListItems")
    }
  }
  
}
