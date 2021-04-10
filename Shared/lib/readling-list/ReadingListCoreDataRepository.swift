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
          articleId: Int16(article.id),
          title: article.title,
          link: article.link,
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
