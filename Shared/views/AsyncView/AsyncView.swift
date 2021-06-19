//
//  AsyncView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 29.05.21.
//

import Combine
import SwiftUI

struct AsyncView<
  Source: Publisher,
  IdleView: View,
  LoadingView: View,
  FailedView: View,
  ContentView: View
>: View {
  let idleView: IdleView
  let loadingView: LoadingView
  let failedView: (Source.Failure) -> FailedView
  let contentView: (Source.Output) -> ContentView

  @ObservedObject var viewModel: AsyncViewModel<Source>

  init(
    source: Source,
    idleView: IdleView,
    loadingView: LoadingView,
    @ViewBuilder failedView: @escaping (Source.Failure)
      -> FailedView,
    @ViewBuilder contentView: @escaping (Source.Output)
      -> ContentView
  ) {
    self.idleView = idleView
    self.loadingView = loadingView
    self.failedView = failedView
    self.contentView = contentView
    viewModel = AsyncViewModel(source: source)
  }

  var body: some View {
    switch viewModel.state {
    case .idle:
      idleView.onAppear { viewModel.load() }
    case .loading:
      loadingView
    case let .loaded(data):
      contentView(data)
    case let .failed(error):
      failedView(error)
    }
  }
}

struct DefaultIdleView: View {
  var body: some View {
    Color.clear
  }
}

struct DefaultLoadingView: View {
  var body: some View {
    ProgressView()
  }
}

struct DefaultFailedView<Failure>: View {
  let failure: Error

  var body: some View {
    Image(systemName: "xmark.octagon.fill").foregroundColor(.red)
  }
}

extension AsyncView where
  IdleView == DefaultIdleView,
  LoadingView == DefaultLoadingView,
  FailedView == DefaultFailedView<Source.Failure> {
  init(
    source: Source,
    @ViewBuilder contentView: @escaping (Source.Output) -> ContentView
  ) {
    self.init(
      source: source,
      idleView: DefaultIdleView(),
      loadingView: DefaultLoadingView(),
      failedView: DefaultFailedView.init,
      contentView: contentView
    )
  }
}

#if DEBUG

  enum AsyncViewError: Error {
    case error
  }

  struct AsyncView_Previews: PreviewProvider {
    static var previews: some View {
      AsyncView(
        source: Bool.random() ? Just("test").delay(for: 2, scheduler: RunLoop.main)
          .setFailureType(to: AsyncViewError.self)
          .eraseToAnyPublisher() : Fail<String, AsyncViewError>(error: AsyncViewError.error).eraseToAnyPublisher(),
        contentView: { _ in Text("Content") }
      )
    }
  }
#endif
