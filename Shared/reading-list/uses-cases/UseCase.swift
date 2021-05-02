//
//  UseCase.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 02.05.21.
//

import Foundation
import Combine

protocol UseCase {
  associatedtype Success
  associatedtype Failure: Error
  
  func start() -> AnyPublisher<Success, Failure>
}
