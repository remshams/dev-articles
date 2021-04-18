//
//  InMemoryRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 17.04.21.
//

import Foundation
import Combine

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
  
  func list() -> AnyPublisher<[Entitiy], DbError> {
    Just(Array(entitiesById.values)).setFailureType(to: DbError.self).eraseToAnyPublisher()
  }
  
  func listBy<Value: Comparable>(keyPath: KeyPath<Entitiy, Value>, ids: [Value]) -> AnyPublisher<[Entitiy], DbError> {
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
  func add(entity: Entitiy) -> AnyPublisher<Entitiy, DbError> {
    entitiesById[entity.id] = entity
    return Just(entity).setFailureType(to: DbError.self).eraseToAnyPublisher()
  }
}
