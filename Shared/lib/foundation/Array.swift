//
//  Array.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 28.03.21.
//

import Foundation

extension Array where Element: Identifiable {
  
  func replaceById(elementId: Element.ID, newElement: Element) -> [Element] {
    var newElements: [Element] = self
    if let elementIndex = self.firstIndex(where: { $0.id == elementId }) {
      newElements.remove(at: elementIndex)
      newElements.insert(newElement, at: elementIndex)
    }
    return newElements
  }
  
}
