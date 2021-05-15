//
//  UseCase.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 02.05.21.
//

import Combine
import Foundation

protocol UseCase {
  associatedtype Success
  associatedtype Failure: Error

  func start() -> AnyPublisher<Success, Failure>
}
