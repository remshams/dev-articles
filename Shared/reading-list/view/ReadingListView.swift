//
//  ReadingListView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 24.07.21.
//

import Foundation
import SwiftUI

struct ReadingListView: View {
  var body: some View {
    ContainerView(model: ReadingListViewModel())
  }
}

private struct ContainerView: View {
  @ObservedObject var model: ReadingListViewModel
  @State var showAddArticle = false
  @State var selectedArticle: ArticleId?

  var body: some View {
    NavigationView {
      List(model.bookmarkedArticles) { bookmarkedArticle in
        NavigationLink(
          destination:
          ArticleContentView(article: bookmarkedArticle.article)
            .navigationTitle(bookmarkedArticle.article.title),
          tag: bookmarkedArticle.id,
          selection: $selectedArticle
        ) {
          ArticleView(article: bookmarkedArticle.article)
        }
      }
      .navigationTitle("Readinglist")
      .toolbar {
        ToolbarItem {
          Button {
            showAddArticle = true
          } label: {
            Image(systemName: "plus")
          }
        }
      }
      .sheet(isPresented: $showAddArticle) {
        AddArticleView { article in
          model.add(article: article)
          showAddArticle = false
          selectedArticle = article.id
        } cancelAddArticle: { showAddArticle = false }
      }
    }
  }
}

#if DEBUG
  struct ReadingListView_Previews: PreviewProvider {
    static var previews: some View {
      ReadingListView()
    }
  }
#endif
