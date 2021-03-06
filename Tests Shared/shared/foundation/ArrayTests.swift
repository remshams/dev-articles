//
//  Collection.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 28.03.21.
//

@testable import dev_articles
import Foundation
import XCTest

struct TestElement: Identifiable, Equatable {
  let id: Int
  let value: String
}

class ArrayTests: XCTestCase {
  var elements: [TestElement]!
  let newElement = TestElement(id: 1, value: "test3")

  override func setUp() {
    elements = [TestElement(id: 0, value: "test1"), TestElement(id: 1, value: "test2")]
  }

  func tests_ReplaceById_ShouldReturnNewArrayWithElementReplaced() {
    let oldElement = elements[1]
    let elementsExpected = [elements.first!, newElement]

    XCTAssertEqual(elements.replaceById(elementId: oldElement.id, newElement: newElement), elementsExpected)
  }

  func tests_ReplaceById_ShouldNotChangeListInCaseElementIdDoesNotExist() {
    XCTAssertEqual(elements.replaceById(elementId: elements.last!.id + 1, newElement: newElement), elements)
  }
}
