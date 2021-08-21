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
        AddArticlePreviewView(state: model.state)
        Spacer()
      }
      .padding(.medium)
      .navigationTitle("Add Article")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button {
            model.loadArticle(for: path, shouldAdd: true)
          } label: { Text("Add") }.disabled(path.isEmpty)
        }
        ToolbarItem(placement: .cancellationAction) {
          Button { model.cancel() } label: { Text("Cancel") }
        }
      }
    }
  }
}

private struct AddArticlePreviewView: View {
  let state: AddArticleViewState

  var body: some View {
    switch state {
    case let .articleLoaded(article):
      LoadedArticleView(article: article)
    case let .error(message):
      LoadArticleErrorView(message: message)
    case .initial:
      NoArticleLoadedView()
    }
  }
}

private struct ArticleLinkView: View {
  private static let linkPlaceholder = "https://dev.to/samuelfaure/is-dev-to-victim-of-its-own-success-1ioj"

  let model: AddArticleViewModel
  @Binding var path: String
  var body: some View {
    HStack {
      TextField(ArticleLinkView.linkPlaceholder, text: $path, onCommit: {
        model.loadArticle(for: path)
      })
        .disableAutocorrection(true)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      Button {
        model.loadArticle(for: path)
      } label: { Text("Preview") }
        .disabled(path.isEmpty)
    }
  }
}

private struct LoadedArticleView: View {
  let article: Article?

  var body: some View {
    if let article = article {
      ArticleCardView(article: article)
    }
  }
}

private struct LoadArticleErrorView: View {
  let message: LocalizedStringKey

  var body: some View {
    Text(message).foregroundColor(.red).italic().fontWeight(.light)
  }
}

private struct NoArticleLoadedView: View {
  var body: some View {
    Text("Enter valid article url").italic().fontWeight(.light)
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
