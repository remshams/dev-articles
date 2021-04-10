//
//  ReadingListItemDbDto+CoreDataProperties.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 21.03.21.
//
//

import Foundation
import CoreData


extension ReadingListItemDbDto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReadingListItemDbDto> {
        return NSFetchRequest<ReadingListItemDbDto>(entityName: "ReadingListItem")
    }

    @NSManaged public var title: String
    @NSManaged public var articleId: Int16
    @NSManaged public var link: URL
    @NSManaged public var savedAt: Date

}

extension ReadingListItemDbDto {
  @nonobjc public class func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<ReadingListItemDbDto> {
    let fetchRequest = NSFetchRequest<ReadingListItemDbDto>(entityName: "ReadingListItem")
    fetchRequest.predicate = predicate
    return fetchRequest
  }
}

extension ReadingListItemDbDto : Identifiable {
  
  func toReadingListItem() -> ReadingListItem {
    ReadingListItem(articleId: Int(articleId), title: title, link: link, savedAt: savedAt)
  }
  
  convenience init(context: NSManagedObjectContext, article: Article, savedAt: Date) {
    self.init(context: context);
    self.title = article.title
    self.articleId = Int16(article.id)
    self.link = article.link
    self.savedAt = savedAt
  }
  
  convenience init(context: NSManagedObjectContext, readingListItem: ReadingListItem) {
    self.init(context: context);
    self.title = readingListItem.title
    self.articleId = Int16(readingListItem.articleId)
    self.link = readingListItem.link
    self.savedAt = readingListItem.savedAt
  }
}
