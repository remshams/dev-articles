//
//  InMemoryRepositoryTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 18.04.21.
//

import Combine
@testable import dev_articles
import Foundation
import XCTest

class InMemoryRepositoryTests: XCTestCase {
  var entities: [DataAccessEntity]!
  var repository: InMemoryRepository<DataAccessEntity>!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    entities = DataAccessEntity.createList(min: 2)
    repository = InMemoryRepository(entities: entities)
    cancellables = []
  }

  func test_list_ShouldEmitEntities() {
    collect(stream$: repository.list(), collect: 1, cancellables: &cancellables)
      .sink(receiveCompletion: { _ in }) {
        XCTAssertEqual($0[0].sorted(), self.entities)
      }
      .store(in: &cancellables)
  }

  func test_listBy_ShouldEmitEntitiesByListOfIds() {
    let byIds = [90, 91]
    let entitiesWithOtherIds = byIds.map {
      DataAccessEntity.create(id: $0, otherId: $0)
    }
    let allEntities = entitiesWithOtherIds + [DataAccessEntity.create()]
    repository = InMemoryRepository(entities: allEntities)

    collect(
      stream$: repository.listBy(keyPath: \DataAccessEntity.otherId, ids: byIds),
      collect: 1,
      cancellables: &cancellables
    )
    .sink(receiveCompletion: { _ in }) {
      XCTAssertEqual($0[0].sorted(), entitiesWithOtherIds)
    }
    .store(in: &cancellables)
  }
}
