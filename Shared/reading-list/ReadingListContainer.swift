//
//  ReadingListContainer.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 17.04.21.
//

import Foundation

class ReadingListContainer: ObservableObject {
  let addReadingListItem: AddReadingListItem
  let listReadingListItem: ListReadingListItem

  init(addReadingListItem: AddReadingListItem, listReadingListItem: ListReadingListItem) {
    self.addReadingListItem = addReadingListItem
    self.listReadingListItem = listReadingListItem
  }
}
