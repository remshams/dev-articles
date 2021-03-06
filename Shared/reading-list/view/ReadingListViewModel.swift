//
//  ReadinglistViewModel.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 24.07.21.
//

import CoreData
import Foundation
import SwiftUI

class ReadingListViewModel: ObservableObject {
  let context: NSManagedObjectContext

  init(context: NSManagedObjectContext) {
    self.context = context
  }

  func add(article: Article) {
    if let readingListItems = try? context.fetch(ReadingListItem.fetchRequest(articleIds: [article.id])),
       readingListItems.isEmpty
    {
      context
        .insert(article.toReadingListItem(context: context))
    }
  }

  func remove(readingListItem: ReadingListItem) {
    context.delete(readingListItem)
  }
}
