//
//  AuthorRestFixture.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 15.07.21.
//

@testable import dev_articles
import Foundation

extension AuthorRestDto {
  static func createFixture(
    username: String = "testUser",
    name: String = "testUser",
    image: String = "https://www.apple.com/de/"
  ) -> AuthorRestDto {
    AuthorRestDto(name: username, username: name, profile_image_90: image)
  }
}
