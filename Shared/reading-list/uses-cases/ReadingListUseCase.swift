//
//  ReadlingListUseCase.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 23.05.21.
//

import Foundation
import Combine

protocol AddReadingListItemFromArticleUseCase {
  
  func start() -> AnyPublisher<ReadingListItem, RepositoryError>
}
