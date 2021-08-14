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
  @EnvironmentObject var container: ReadingListContainer
  @ObservedObject var model: ReadingListViewModel
  @State var showAddArticle = false
  @State var selectedArticle: ArticleId?
  @FetchRequest(
    entity: ReadingListItem.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \ReadingListItem.savedAt, ascending: true)]
  ) var allArticles: FetchedResults<ReadingListItem>

  var body: some View {
    NavigationView {
      List(allArticles) { bookmarkedArticle in
        NavigationLink(
          destination:
          container.makeArticleContentView(articleId: bookmarkedArticle.contentId)
            .navigationTitle(bookmarkedArticle.title),
          tag: bookmarkedArticle.contentId,
          selection: $selectedArticle
        ) {
          ReadingListItemView(readingListItem: bookmarkedArticle)
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
          model.add(article: article, readingListItems: allArticles)
          showAddArticle = false
          selectedArticle = article.id
        } cancelAddArticle: { showAddArticle = false }
      }
    }
  }
}

private struct ReadingListItemView: View {
  let readingListItem: ReadingListItem

  var body: some View {
    Text(readingListItem.title)
  }
}

#if DEBUG
  struct ReadingListView_Previews: PreviewProvider {
    static var previews: some View {
      ReadingListView()
    }
  }
#endif
