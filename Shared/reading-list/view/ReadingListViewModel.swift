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

  init(context: NSManagedObjectContext = AppContainer.shared.persistence.context) {
    self.context = context
  }

  func add(article: Article) {
    if let readingListItems = try? context.fetch(ReadingListItem.fetchRequest(articleIds: [article.id])),
       readingListItems.isEmpty {
      AppContainer.shared.persistence.context
        .insert(article.toReadingListItem(context: context))
    }
  }
}
