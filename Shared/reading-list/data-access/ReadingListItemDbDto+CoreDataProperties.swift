//
//  ReadingListItemDbDto+CoreDataProperties.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 21.03.21.
//
//

import CoreData
import Foundation

public extension ReadingListItemDbDto {
  @nonobjc class func fetchRequest() -> NSFetchRequest<ReadingListItemDbDto> {
    return NSFetchRequest<ReadingListItemDbDto>(entityName: "ReadingListItem")
  }

  @NSManaged var title: String
  @NSManaged var contentId: String
  @NSManaged var link: URL
  @NSManaged var savedAt: Date
}

public extension ReadingListItemDbDto {
  @nonobjc class func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<ReadingListItemDbDto> {
    let fetchRequest = NSFetchRequest<ReadingListItemDbDto>(entityName: "ReadingListItem")
    fetchRequest.predicate = predicate
    return fetchRequest
  }
}

extension ReadingListItemDbDto: Identifiable {
  func toReadingListItem() -> ReadingListItem {
    ReadingListItem(contentId: contentId, title: title, link: link, savedAt: savedAt)
  }

  convenience init(context: NSManagedObjectContext, article: Article, savedAt: Date) {
    self.init(context: context)
    title = article.title
    contentId = article.id
    link = article.link
    self.savedAt = savedAt
  }

  convenience init(context: NSManagedObjectContext, readingListItem: ReadingListItem) {
    self.init(context: context)
    title = readingListItem.title
    contentId = readingListItem.contentId
    link = readingListItem.link
    savedAt = readingListItem.savedAt
  }
}
