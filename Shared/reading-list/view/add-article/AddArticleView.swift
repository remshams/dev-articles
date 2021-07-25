//
//  AddArticleView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 25.07.21.
//

import Foundation
import SwiftUI

struct AddArticleView: View {
  let addArticle: AddArticle
  let cancelAddArticle: CancelAddArticle

  var body: some View {
    ContainerView(model: AddArticleViewModel(addArticle: addArticle, cancelAddArticle: cancelAddArticle))
  }
}

private struct ContainerView: View {
  @ObservedObject var model: AddArticleViewModel
  @State var link: String = ""

  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        ArticleLinkView(model: model)
        LoadedArticleView(article: model.article)
        Spacer()
      }
      .navigationTitle("Add Article")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button {
            model.add()
          } label: { Text("Save") }.disabled(model.article == nil)
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
  @State var link: String = ""
  var body: some View {
    VStack {
      TextField("Article Link", text: $link, onCommit: {
        model.loadArticle(for: link)
      })
        .disableAutocorrection(true)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.medium)
    }
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
    }
  }
#endif
