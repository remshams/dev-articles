//
//  Article+CoreDataProperties.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 21.03.21.
//
//

import Foundation
import CoreData


extension ArticleDbDto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleDbDto> {
        return NSFetchRequest<ArticleDbDto>(entityName: "Article")
    }

    @NSManaged public var articleDescription: String
    @NSManaged public var id: Int16
    @NSManaged public var link: URL
    @NSManaged public var title: String

}

extension ArticleDbDto : Identifiable {

}
