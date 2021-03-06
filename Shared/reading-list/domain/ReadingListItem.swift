//
//  ReadingListItemDbDto+CoreDataClass.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 21.03.21.
//
//

import CoreData
import Foundation

typealias ContentId = String

@objc(ReadingListItem)
public class ReadingListItem: NSManagedObject {
  @NSManaged private(set) var title: String
  @NSManaged private(set) var contentId: String
  @NSManaged private(set) var savedAt: Date

  convenience init(context: NSManagedObjectContext, title: String, contentId: String, savedAt: Date = Date()) {
    self.init(context: context)
    self.title = title
    self.contentId = contentId
    self.savedAt = savedAt
  }
}

extension ReadingListItem: Identifiable {
  @nonobjc class func fetchRequestAll() -> NSFetchRequest<ReadingListItem> {
    NSFetchRequest<ReadingListItem>(entityName: "ReadingListItem")
  }

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
