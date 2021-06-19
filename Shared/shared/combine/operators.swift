//
//  Publisher.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 03.06.21.
//

import Combine
import Foundation

extension Publisher where Output == Data {
  func decode<Model: Decodable>(to type: Model.Type = Model.self, decoder: JSONDecoder = .init()) -> Publishers
    .Decode<Self, Model, JSONDecoder> {
    decode(type: type, decoder: decoder)
  }
}
