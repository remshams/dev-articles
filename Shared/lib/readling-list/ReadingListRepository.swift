//
//  ReadingListRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 21.03.21.
//

import Foundation

protocol AddReadingListItem {
  func addFrom(article: Article) -> Void
}

protocol ListReadingListItem {
  func list() -> [ReadlingListItem]
}
