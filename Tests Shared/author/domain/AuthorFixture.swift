//
//  File.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 15.07.21.
//

@testable import dev_articles
import Foundation

extension Author {
  static func createFixture(
    username: String = "testUser",
    name: String = "testUser",
    image: URL = URL(string: "https://www.apple.com/de/")!
  ) -> Author {
    Author(username: username, name: name, image: image)
  }
}
