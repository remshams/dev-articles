//
//  ReadingListView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 24.07.21.
//

import Foundation
import SwiftUI

struct ReadingListView: View {
  @EnvironmentObject var readingListContainer: ReadingListContainer
  var body: some View {
    ContainerView(model: readingListContainer.makeReadingListViewModel())
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
  ) var readingListItems: FetchedResults<ReadingListItem>

  var body: some View {
    NavigationView {
      List {
        ForEach(readingListItems) { readingListItem in
          NavigationLink(
            destination:
            container.makeArticleContentView(articleId: readingListItem.contentId)
              .navigationTitle(readingListItem.title),
            tag: readingListItem.contentId,
            selection: $selectedArticle
          ) {
            ReadingListItemView(readingListItem: readingListItem)
          }
        }
        .onDelete(perform: delete)
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
        ToolbarItem(placement: .navigationBarLeading) {
          EditButton()
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

  private func delete(at index: IndexSet) {
    index.forEach {
      model.remove(readingListItem: readingListItems[$0])
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
