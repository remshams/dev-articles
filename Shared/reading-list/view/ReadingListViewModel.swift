//
//  ReadinglistViewModel.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 24.07.21.
//

import Foundation
import SwiftUI

class ReadingListViewModel: ObservableObject {
  func add(article: Article, readingListItems: FetchedResults<ReadingListItem>) {
    if readingListItems.firstIndex(where: { $0.contentId == article.id }) == nil {
      AppContainer.shared.persistence.context
        .insert(ReadingListItem(context: AppContainer.shared.persistence.context, from: article,
                                savedAt: Date()))
    }
  }
}
