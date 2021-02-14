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
  private let articles = CurrentValueSubject<[Article], Never>([])
  @Published var articleTitles: [String] = []
  
  init(listArticle: ListArticle) {
    self.listArticle = listArticle
    
    setupLoadArticles()
    setupArticleTitles()
  }
  
  func loadArticles() -> Void {
    loadArticles$.send()
  }
  
  private func setupLoadArticles() -> Void {
    loadArticles$.flatMap({[unowned self] in
      self.listArticle.list$()
    })
    .replaceError(with: [])
    .assign(to: \.value, on: self.articles)
    .store(in: &cancellables)
  }
  
  private func setupArticleTitles() -> Void {
    articles
      .map({$0.map(\.title)})
      .assign(to: \.articleTitles, on: self)
      .store(in: &cancellables)
  }
  
}
