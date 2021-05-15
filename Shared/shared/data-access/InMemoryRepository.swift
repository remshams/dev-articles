//
//  InMemoryRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 17.04.21.
//

import Combine
import Foundation

class InMemoryRepository<Entitiy: Identifiable> {
  var entitiesById: [Entitiy.ID: Entitiy]

  init(entitiesById: [Entitiy.ID: Entitiy] = [:]) {
    self.entitiesById = entitiesById
  }

  convenience init(entities: [Entitiy]) {
    self.init(entitiesById: entities.toDictionaryById())
  }
}

extension InMemoryRepository {
  func list() -> AnyPublisher<[Entitiy], RepositoryError> {
    Just(Array(entitiesById.values)).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }

  func listBy<Value: Comparable>(keyPath: KeyPath<Entitiy, Value>,
                                 ids: [Value]) -> AnyPublisher<[Entitiy], RepositoryError>
  {
    list()
      .map { entities in
        entities.filter { entity in
          ids.contains {
            entity[keyPath: keyPath] == $0
          }
        }
      }
      .eraseToAnyPublisher()
  }
}

extension InMemoryRepository {
  func add(entity: Entitiy) -> AnyPublisher<Entitiy, RepositoryError> {
    entitiesById[entity.id] = entity
    return Just(entity).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}
