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

extension ReadingListItemDbDto : Identifiable {
  func toReadingListItem() -> ReadingListItem {
    ReadingListItem(articleId: Int(articleId), title: title, link: link, savedAt: savedAt)
  }
  
  convenience init(context: NSManagedObjectContext, articleId: Int16, title: String, link: URL, savedAt: Date) {
    self.init(context: context);
    self.title = title
    self.articleId = articleId
    self.link = link
    self.savedAt = savedAt
  }
}
