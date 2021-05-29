//
//  LoadingState.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 29.05.21.
//

import Foundation

enum LoadingState<Data, Failure: Error> {
  case idle
  case loading
  case loaded(Data)
  case failed(Failure)
}
