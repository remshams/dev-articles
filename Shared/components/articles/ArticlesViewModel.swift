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
  
  @Published private(set) var articles: [Article] = []
  @Published var selectedTimeCategory = TimeCategory.feed
  
  init(listArticle: ListArticle) {
    self.listArticle = listArticle
    
    setupLoadArticles()
    loadArticles()
  }
  
  func loadArticles() -> Void {
    loadArticles$.send()
  }
  
  private func setupLoadArticles() -> Void {
    $selectedTimeCategory.flatMap({ [unowned self] timeCategory in
      self.listArticle.list$(for: timeCategory)
    })
    .receive(on: DispatchQueue.main)
    .replaceError(with: [])
    .assign(to: \.articles, on: self)
    .store(in: &cancellables)
  }
  
}
