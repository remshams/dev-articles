//
//  presenter.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 06.02.21.
//

import Foundation
import Combine

class ArticlesViewModel: ObservableObject {
  private let articlesRestAdapter: ArticlesRestAdapter
  private var cancellables: Set<AnyCancellable> = []
  
  private let loadArticles$ = PassthroughSubject<Void, Never>()
  @Published private var articles: [Article] = []
  @Published var articleTitles: [String] = []
  
  init(articlesRestAdapter: ArticlesRestAdapter) {
    self.articlesRestAdapter = articlesRestAdapter
    
    setupLoadArticles()
    setupArticleTitles()
  }
  
  func loadArticles() -> Void {
    loadArticles$.send()
  }
  
  private func setupLoadArticles() -> Void {
    loadArticles$.flatMap({[unowned self] in
      self.articlesRestAdapter.list$()
    })
    .replaceError(with: [])
    .assign(to: \.articles, on: self)
    .store(in: &cancellables)
  }
  
  private func setupArticleTitles() -> Void {
    $articles
      .map({$0.map(\.title)})
      .assign(to: \.articleTitles, on: self)
      .store(in: &cancellables)
  }
  
}
