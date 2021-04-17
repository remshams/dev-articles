//
//  ArticlesContainer.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 17.04.21.
//

import Foundation

class ArticlesContainer: ObservableObject {
  let listArticle: ListArticle
  
  init(listArticle: ListArticle) {
    self.listArticle = listArticle
  }
}
