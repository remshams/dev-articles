//
//  DataAccessFixture.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 18.04.21.
//

import Foundation

struct DataAccessEntity: Identifiable, Equatable {
  let id: Int
  let otherId: Int
  let content: String
}

extension DataAccessEntity {
  
  static func create(id: Int = 0, otherId: Int = 1, content: String = "content") -> DataAccessEntity {
    DataAccessEntity(id: id, otherId: otherId, content: content)
  }
  
  static func createList(min: Int = 0, max: Int = 12) -> [DataAccessEntity] {
    (0...Int.random(in: min...max))
      .map {
        create(id: $0)
      }
  }
  
}

extension DataAccessEntity: Comparable {
  static func < (lhs: DataAccessEntity, rhs: DataAccessEntity) -> Bool {
    lhs.id < rhs.id
  }
  
  
}
