//
//  AsyncViewModel.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 29.05.21.
//

import Combine
import Foundation

class AsyncViewModel<Source: Publisher>: ObservableObject {
  private var cancellables: Set<AnyCancellable> = []

  let source: Source
  @Published var state: LoadingState<Source.Output, Source.Failure> = .idle

  init(source: Source) {
    self.source = source
  }

  func load() {
    state = .loading
    source
      .map { LoadingState.loaded($0) }
      .catch { Just(LoadingState.failed($0)) }
      .assign(to: \.state, on: self)
      .store(in: &cancellables)
  }
}
