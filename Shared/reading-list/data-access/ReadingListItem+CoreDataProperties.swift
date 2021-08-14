//
//  ReadingListItemDbDto+CoreDataProperties.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 21.03.21.
//
//

import CoreData
import Foundation

public extension ReadingListItem {
  @nonobjc class func fetchRequest() -> NSFetchRequest<ReadingListItem> {
    NSFetchRequest<ReadingListItem>(entityName: "ReadingListItem")
  }

  @NSManaged private(set) var title: String
  @NSManaged private(set) var contentId: String
  @NSManaged private(set) var savedAt: Date
}

public extension ReadingListItem {
  @nonobjc class func fetchRequest(predicate: NSPredicate? = nil) -> NSFetchRequest<ReadingListItem> {
    let fetchRequest = NSFetchRequest<ReadingListItem>(entityName: "ReadingListItem")
    if let predicate = predicate {
      fetchRequest.predicate = predicate
    }
    return fetchRequest
  }
}

extension ReadingListItem: Identifiable {
  convenience init(context: NSManagedObjectContext, from article: Article, savedAt: Date) {
    self.init(context: AppContainer.shared.managedObjectContext)
    title = article.title
    contentId = article.id
    self.savedAt = savedAt
  }

  convenience init(context: NSManagedObjectContext, readingListItem: ReadingListItem) {
    self.init(context: context)
    title = readingListItem.title
    contentId = readingListItem.contentId
    savedAt = readingListItem.savedAt
  }
}
