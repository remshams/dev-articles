//
//  ArticlesRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 18.04.21.
//

import Foundation
import Combine

protocol ArticlesRepository: ListArticle {
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError>
}
