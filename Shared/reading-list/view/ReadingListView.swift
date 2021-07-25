//
//  File.swift
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
  let model: ReadingListViewModel
  @State var articleLink: String = ""

  var body: some View {
    NavigationView {
      List(model.bookmarkedArticles) { article in
        Text(article.article.title)
      }
      .navigationTitle("Readinglist")
      .toolbar {
        ToolbarItem {
          Image(systemName: "plus")
        }
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
