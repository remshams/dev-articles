//
//  ArticlesContainer.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 17.04.21.
//

import Foundation

class ArticlesContainer: ObservableObject {
  let getArticle: GetArticle
  let listArticle: ListArticle
  let listArticleContent: ListArticleContent
  let addReadingListItem: AddReadingListItem

  init(
    listArticle: ListArticle,
    getArticle: GetArticle,
    listArticleContent: ListArticleContent,
    addReadingListItem: AddReadingListItem
  ) {
    self.getArticle = getArticle
    self.listArticle = listArticle
    self.listArticleContent = listArticleContent
    self.addReadingListItem = addReadingListItem
  }

  func makeArticlesViewModel() -> ArticlesViewModel {
    ArticlesViewModel(articlesUseCaseFactory: self)
  }

  func makeArticleContentViewModel(articleId: ArticleId) -> ArticleContentViewModel {
    ArticleContentViewModel(getArticle: getArticle, listArticleContent: listArticleContent, articleId: articleId)
  }
}

extension ArticlesContainer: ArticlesUseCaseFactory {
  func makeLoadArticlesUseCase(timeCategory: TimeCategory, page: Int, pageSize: Int) -> LoadArticlesUseCase {
    AppLoadArticlesUseCase(listArticle: listArticle, timeCategory: timeCategory, page: page, pageSize: pageSize)
  }

  func makeLoadArticlesUseCase(timeCategory: TimeCategory, page: Int) -> LoadArticlesUseCase {
    makeLoadArticlesUseCase(timeCategory: timeCategory, page: page, pageSize: 20)
  }

  func makeAddReadlingListItemFromArticleUseCase(article: Article) -> AddReadingListItemFromArticleUseCase {
    AppAddReadingListItemFromArticleUseCase(addReadingListItem: addReadingListItem, article: article)
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
    listArticleContent: InMemoryArticleContentRepository(),
    addReadingListItem: InMemoryReadingListRepository(readingListItems: [])
  )
#endif
