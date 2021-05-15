import Foundation

extension Collection where Element: Identifiable {
  func toDictionaryById() -> [Element.ID: Element] {
    reduce(into: [:]) { result, element in
      result[element.id] = element
    }
  }
}
