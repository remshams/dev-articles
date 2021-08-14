//
//  ReadingListItemDbDto+CoreDataProperties.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 21.03.21.
//
//

import CoreData
import Foundation

extension ReadingListItem {
  @nonobjc class func fetchRequest() -> NSFetchRequest<ReadingListItem> {
    NSFetchRequest<ReadingListItem>(entityName: "ReadingListItem")
  }

  @NSManaged private(set) var title: String
  @NSManaged private(set) var contentId: String
  @NSManaged private(set) var savedAt: Date
}

extension ReadingListItem {
  @nonobjc class func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<ReadingListItem> {
    let fetchRequest = NSFetchRequest<ReadingListItem>(entityName: "ReadingListItem")
    fetchRequest.predicate = predicate
    return fetchRequest
  }

  @nonobjc class func fetchRequest(articleIds: [ArticleId]) -> NSFetchRequest<ReadingListItem> {
    let fetchRequest = NSFetchRequest<ReadingListItem>(entityName: "ReadingListItem")
    fetchRequest.predicate = NSPredicate(format: "contentId IN %@", articleIds.map { String($0) })
    return fetchRequest
  }
}

extension ReadingListItem: Identifiable {
  convenience init(context _: NSManagedObjectContext, from article: Article, savedAt: Date) {
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
