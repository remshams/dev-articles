//
//  ArticleContentView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 19.06.21.
//

import Combine
import Foundation
import SwiftUI
import WebKit

struct ArticleContentView: View {
  @EnvironmentObject var articlesContainer: ArticlesContainer
  let articleId: ArticleId
  let article: Article?

  init(articleId: ArticleId) {
    self.articleId = articleId
    article = nil
  }

  init(article: Article) {
    self.article = article
    articleId = article.id
  }

  var body: some View {
    if let article = article {
      ContainerView(model: articlesContainer.makeArticleContentViewModel(article: article))
    } else {
      ContainerView(model: articlesContainer.makeArticleContentViewModel(articleId: articleId))
    }
  }
}

private struct ContainerView: View {
  @ObservedObject var model: ArticleContentViewModel

  init(model: ArticleContentViewModel) {
    self.model = model
  }

  var body: some View {
    Group {
      switch model.state {
      case let .loaded(article, content):
        ArticleContentLoadedView(article: article, content: content)
      case .loading:
        ArticleContentLoadingView()
      case .error:
        ErrorArticleContentView()
      }
    }
    .onAppear {
      model.loadContent()
    }
  }
}

private struct ArticleContentLoadedView: View {
  @State var articleContentHeight: CGFloat = .zero
  let article: Article
  let content: ArticleContent

  var body: some View {
    ScrollView {
      HeaderView(article: article)
      ArticleContentWebView(content: content, webViewHeight: $articleContentHeight).frame(
        height: articleContentHeight
      )
      // Next the making the content stand out, the leading padding enables
      // dragging the scrollbar on the right on macOS.
      .padding(.trailing, .small)
      .padding(.leading, .small)
    }
    .toolbar {
      ToolbarItem {
        Button { Application.openLink(url: article.metaData.link) } label: {
          Image(systemName: "safari").foregroundColor(Color.accentColor)
        }
      }
    }
  }
}

private struct ArticleContentLoadingView: View {
  var body: some View {
    ProgressView()
  }
}

private struct ErrorArticleContentView: View {
  var body: some View {
    Text("Article could not be loaded")
  }
}

private struct HeaderView: View {
  let article: Article

  var body: some View {
    CoverImage(url: article.metaData.coverImageUrl)
    VStack(alignment: .leading, spacing: .medium) {
      HStack(spacing: .large) {
        AuthorView(author: article.author)
        MetadataView(metadata: article.metaData)
        CommunityDataView(communityData: article.communityData)
        Spacer()
      }
      TagsView(tags: article.tags)
    }.padding(.leading, .medium)
  }
}

private struct MetadataView: View {
  let metadata: ArticleMetaData

  var body: some View {
    HStack {
      VStack(spacing: .small) {
        Image(systemName: "timer").foregroundColor(.gray)
        Image(systemName: "icloud.and.arrow.up").foregroundColor(.gray)
      }
      VStack(alignment: .leading, spacing: .extraSmall) {
        Text("\(metadata.readingTime)")
        Text(metadata.publishedAt ?? Date(), formatter: DateFormatter.simpleDateFormatter)
      }
    }
  }
}

private struct CommunityDataView: View {
  let communityData: ArticleCommunityData

  var body: some View {
    HStack {
      VStack(spacing: .small) {
        Image(systemName: "suit.heart.fill").foregroundColor(.red)
        Image(systemName: "text.bubble").foregroundColor(.gray)
      }
      VStack(alignment: .trailing, spacing: .extraSmall) {
        Text("\(communityData.positiveReactionsCount)")
        Text("\(communityData.commentsCount)")
      }
    }
  }
}

private struct AuthorView: View {
  let author: Author
  var body: some View {
    HStack {
      AsyncImage(url: author.image)
        .frame(width: 40, height: 40)
        .aspectRatio(contentMode: .fit)
        .clipShape(Circle())
      Text(author.username).fontWeight(.bold).font(.subheadline)
    }
  }
}

private struct TagsView: View {
  let tags: [String]

  var body: some View {
    HStack {
      ForEach(tags, id: \.self) {
        TagView(tag: $0)
      }
    }
  }
}

private struct TagView: View {
  @Environment(\.colorScheme) var colorScheme
  let tag: String
  let textColor = Color.black.opacity(0.7)

  var body: some View {
    Text(tag)
      .padding(4)
      .foregroundColor(colorScheme == .light ? Color.black.opacity(0.5) : Color.white.opacity(0.5))
      .background(colorScheme == .light ? Color.gray.brightness(0.3) : Color.black.brightness(0.5))
      .cornerRadius(5)
  }
}

private struct CoverImage: View {
  let url: URL?

  var body: some View {
    if let url = url {
      AsyncImage(url: url).aspectRatio(contentMode: .fit)
    } else {
      // Empty rectangle for having the same paddings as when an
      // image is returned.
      Rectangle().frame(width: 0, height: 0)
    }
  }
}

#if DEBUG
  struct ArticleContent_Previews: PreviewProvider {
    static var previews: some View {
      ArticleContentView(articleId: articleForPreview.id).environmentObject(
        articleContainerForPreview
      ).preferredColorScheme(.dark)
    }
  }
#endif
