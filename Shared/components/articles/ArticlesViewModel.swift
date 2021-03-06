//
//  presenter.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 06.02.21.
//

import Foundation
import Combine

class ArticlesViewModel: ObservableObject {
  private let listArticle: ListArticle
  private var cancellables: Set<AnyCancellable> = []
  
  private let loadArticles$ = PassthroughSubject<Void, Never>()
  @Published var articles: [Article] = []
  
  init(listArticle: ListArticle) {
    self.listArticle = listArticle
    
    setupLoadArticles()
  }
  
  func loadArticles() -> Void {
    loadArticles$.send()
  }
  
  private func setupLoadArticles() -> Void {
    loadArticles$.flatMap({[unowned self] in
      self.listArticle.list$(for: .feed)
    })
    .replaceError(with: [])
    .assign(to: \.articles, on: self)
    .store(in: &cancellables)
  }
  
}
