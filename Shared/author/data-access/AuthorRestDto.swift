//
//  AuthorRestDto.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 13.07.21.
//

import Foundation

struct AuthorRestDto: Codable {
  let name: String
  let username: String
  // swiftlint:disable identifier_name
  let profile_image_90: String
  // swiftlint:enable identifier_name
}

extension AuthorRestDto {
  func toAuthor() -> Author {
    Author(username: username, name: name, image: URL(string: profile_image_90)!)
  }
}
