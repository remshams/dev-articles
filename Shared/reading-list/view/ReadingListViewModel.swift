//
//  ReadinglistViewModel.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 24.07.21.
//

import Foundation
import SwiftUI

class ReadingListViewModel: ObservableObject {
  @Published var bookmarkedArticles: [BookmarkedArticle] = []

  func add(article: Article) {
    if bookmarkedArticles.firstIndex(where: { $0.id == article.id }) == nil {
      bookmarkedArticles.append(BookmarkedArticle.from(article: article))

      do {
        let context = PersistenceController.shared.context
        context
          .insert(ReadingListItem(context: PersistenceController.shared.context, article: article,
                                  savedAt: Date()))
        try context.save()
      } catch {
        print("Save Error")
      }
    }
  }
}
