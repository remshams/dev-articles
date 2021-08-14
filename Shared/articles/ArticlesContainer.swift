//
//  ArticlesContainer.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 17.04.21.
//

import CoreData
import Foundation

class ArticlesContainer: ObservableObject {
  let getArticle: GetArticle
  let listArticle: ListArticle
  let listArticleContent: ListArticleContent

  init(
    listArticle: ListArticle,
    getArticle: GetArticle,
    listArticleContent: ListArticleContent
  ) {
    self.getArticle = getArticle
    self.listArticle = listArticle
    self.listArticleContent = listArticleContent
  }

  func makeArticlesViewModel() -> ArticlesViewModel {
    ArticlesViewModel(articlesUseCaseFactory: self)
  }

  func makeArticleContentViewModel(articleLoader: ArticleLoader) -> ArticleContentViewModel {
    ArticleContentViewModel(articleLoader: articleLoader, listArticleContent: listArticleContent)
  }
}

extension ArticlesContainer: ArticlesUseCaseFactory {
  func makeLoadArticlesUseCase(timeCategory: TimeCategory, page: Int, pageSize: Int) -> LoadArticlesUseCase {
    AppLoadArticlesUseCase(listArticle: listArticle, timeCategory: timeCategory, page: page, pageSize: pageSize)
  }

  func makeLoadArticlesUseCase(timeCategory: TimeCategory, page: Int) -> LoadArticlesUseCase {
    makeLoadArticlesUseCase(timeCategory: timeCategory, page: page, pageSize: 20)
  }
}

#if DEBUG
  let articlesRepository = InMemoryArticlesRepository(
    articles: [
      articleForPreview,
      articleForPreview
    ]
  )
  let articleContainerForPreview = ArticlesContainer(
    listArticle: articlesRepository,
    getArticle: articlesRepository,
    listArticleContent: InMemoryArticleContentRepository()
  )
#endif
