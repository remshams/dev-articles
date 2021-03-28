//
//  ReadingListRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 21.03.21.
//

import Foundation
import CoreData
import Combine

class ReadingListCoreDataRepository: AddReadingListItem, ListReadingListItem  {
  private let managedObjectContext: NSManagedObjectContext
  
  init(managedObjectContext: NSManagedObjectContext) {
    self.managedObjectContext = managedObjectContext
  }
  
  
  func addFrom(article: Article) -> AnyPublisher<Bool, DbError> {
    return Just(article)
      .tryMap { article in
        let readingListItem = ReadingListItemDbDto(context: managedObjectContext)
        readingListItem.articleId = Int16(article.id)
        readingListItem.title = article.title
        readingListItem.link = article.link
        readingListItem.savedAt = Date()
        try managedObjectContext.save()
        return true
      }
      .mapError { error in
        DbError.error
      }
      .eraseToAnyPublisher()
  }
  
  func list() -> AnyPublisher<[ReadingListItem], DbError> {
    let fetchRequest = NSFetchRequest<ReadingListItemDbDto>(entityName: "ReadingListItem")
    return Just(fetchRequest)
      .tryMap { fetchRequest in
        try managedObjectContext.fetch(fetchRequest)
      }
      .map { readingListItemDtos in
        readingListItemDtos.map { $0.toReadingListItem() }
      }
      .mapError { error in DbError.error }
      .eraseToAnyPublisher()
  }
  
  func list(for articles: [ArticleId]) -> AnyPublisher<[ReadingListItem], DbError> {
    fatalError("Not Implemented")
  }
  
}
