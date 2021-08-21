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

// MARK: Content

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
    case let .error(error):
      ArticleErrorContainerView(error: error)
    case .initial:
      EmptyView()
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

// MARK: Loading

private struct LoadedArticleView: View {
  let article: Article?

  var body: some View {
    if let article = article {
      ArticleCardView(article: article).padding(.top, .medium)
      Spacer()
    }
  }
}

private struct NoArticleLoadedView: View {
  var body: some View {
    EmptyView()
  }
}

// MARK: Error

private struct ArticleErrorContainerView: View {
  let error: AddArticleViewError

  var body: some View {
    VStack {
      HStack {
        switch error {
        case .notFound:
          ArticleErrorView(code: "404", message: "Article not found")
        case .notLoaded:
          ArticleErrorView(code: "500", message: "Article load error")
        case .urlInvalid:
          ArticleErrorView(code: "500", message: "Article Url invalid")
        }
      }.frame(maxWidth: .infinity)
    }.frame(maxHeight: .infinity)
  }
}

private struct ArticleErrorView: View {
  let (code, message): (String, LocalizedStringKey)

  var body: some View {
    VStack {
      Text(code).font(.largeTitle).bold()
      Text(message).italic().fontWeight(.light)
    }
  }
}

#if DEBUG
  struct AddArticleView_Previews: PreviewProvider {
    static var previews: some View {
      AddArticleView(addArticle: { _ in }, cancelAddArticle: {})
        .environmentObject(readingListContainerForPreview)
      ArticleErrorView(code: "404", message: "Article not found")
    }
  }
#endif
