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
  
  
  func addFrom(article: Article) -> AnyPublisher<ReadingListItem, DbError> {
    return Just(article)
      .tryMap { article in
        let readingListItemDto = ReadingListItemDbDto(
          context: managedObjectContext,
          article: article,
          savedAt: Date()
        )
        try managedObjectContext.save()
        return readingListItemDto.toReadingListItem()
      }
      .mapError { error in
        DbError.error
      }
      .eraseToAnyPublisher()
  }
  
  func list() -> AnyPublisher<[ReadingListItem], DbError> {
    let fetchRequest: NSFetchRequest<ReadingListItemDbDto> = ReadingListItemDbDto.fetchRequest()
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
  
  func list(for articleIds: [ArticleId]) -> AnyPublisher<[ReadingListItem], DbError> {
    return Just(ReadingListItemDbDto.fetchRequest(predicate: NSPredicate(format: "articleId IN %@", articleIds.map { String($0) })))
      .tryMap { fetchRequest in
        try managedObjectContext.fetch(fetchRequest)
      }
      .map { readingListItemDbDtos in
        readingListItemDbDtos.map { $0.toReadingListItem() }
      }
      .mapError { error in DbError.error }
      .eraseToAnyPublisher()
  }
  
}