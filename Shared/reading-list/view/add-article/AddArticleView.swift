//
//  AddArticleView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 25.07.21.
//

import Foundation
import SwiftUI

struct AddArticleView: View {
  @EnvironmentObject var readingListContainer: ReadingListContainer
  let addArticle: AddArticle
  let cancelAddArticle: CancelAddArticle

  var body: some View {
    ContainerView(model: readingListContainer
      .makeAddArticleViewModel(addArticle: addArticle, cancelAddArticle: cancelAddArticle))
  }
}

private struct ContainerView: View {
  @ObservedObject var model: AddArticleViewModel
  @State var path: String = ""

  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        ArticleLinkView(model: model, path: $path)
        LoadedArticleView(article: model.article)
        Spacer()
      }
      .navigationTitle("Add Article")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button {
            model.add()
          } label: { Text("Add") }.disabled(path.isEmpty)
        }
        ToolbarItem(placement: .cancellationAction) {
          Button { model.cancel() } label: { Text("Cancel") }
        }
      }
    }
  }
}

private struct ArticleLinkView: View {
  let model: AddArticleViewModel
  @Binding var path: String
  var body: some View {
    HStack {
      TextField("Article Link", text: $path, onCommit: {
        model.loadArticle(for: path)
      })
        .disableAutocorrection(true)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      Button {
        model.loadArticle(for: path)
      } label: { Text("Preview") }
        .disabled(path.isEmpty)
    }
    .padding(.medium)
  }
}

private struct LoadedArticleView: View {
  let article: Article?

  var body: some View {
    if let article = article {
      ArticleCardView(article: article)
        .padding(.medium)
    }
  }
}

#if DEBUG
  struct AddArticleView_Previews: PreviewProvider {
    static var previews: some View {
      AddArticleView(addArticle: { _ in }, cancelAddArticle: {})
        .environmentObject(readingListContainerForPreview)
    }
  }
#endif
