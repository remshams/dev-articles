import Foundation

extension Collection where Element: Identifiable {
  func toDictionaryById() -> [Element.ID: Element] {
    self.reduce(into: [:]) { result, element in
      result[element.id] = element
    }
  }
}
