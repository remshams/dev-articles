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
  let article: Article

  var body: some View {
    ContainerView(model: articlesContainer.makeArticleContentViewModel(article: article))
  }
}

private struct ContainerView: View {
  @ObservedObject var model: ArticleContentViewModel
  @State var articleContentHeight: CGFloat = .zero

  init(model: ArticleContentViewModel) {
    self.model = model
  }

  var body: some View {
    ScrollView {
      HeaderView(article: model.article)
      ArticleContentWebView(content: model.content, webViewHeight: $articleContentHeight).frame(
        height: articleContentHeight
      )
    }.onAppear {
      model.loadContent()
    }
  }
}

private struct HeaderView: View {
  let article: Article

  var body: some View {
    VStack(alignment: .leading) {
      CoverImage(url: article.metaData.coverImageUrl)
      VStack(alignment: .leading) {
        Text(article.title).font(.largeTitle).foregroundColor(.black)
        VStack(alignment: .leading, spacing: 16) {
          HStack(spacing: 32) {
            AuthorView(author: article.author)
            MetadataView(metadata: article.metaData)
            CommunityDataView(communityData: article.communityData)
          }
          TagsView(tags: article.tags)
        }
      }.padding(.leading, 16).padding(.trailing, 16)
    }
  }
}

private struct MetadataView: View {
  let metadata: ArticleMetaData

  var body: some View {
    HStack {
      VStack(spacing: 8) {
        Image(systemName: "timer").foregroundColor(.gray)
        Image(systemName: "icloud.and.arrow.up").foregroundColor(.gray)
      }
      VStack(alignment: .leading, spacing: 6) {
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
      VStack(spacing: 8) {
        Image(systemName: "suit.heart.fill").foregroundColor(.red)
        Image(systemName: "text.bubble").foregroundColor(.gray)
      }
      VStack(alignment: .trailing, spacing: 6) {
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
  let tag: String
  let textColor = Color.black.opacity(0.7)

  var body: some View {
    Text(tag)
      .padding(4)
      .foregroundColor(Color.black.opacity(0.5))
      .background(Color.gray.brightness(0.3))
      .cornerRadius(5)
  }
}

/*
 * TODO Placeholder will image is loading
 * Image ScaleToFit
 */
private struct CoverImage: View {
  let url: URL?

  var body: some View {
    Group {
      if let url = url {
        AsyncImage(url: url).aspectRatio(contentMode: .fit)
      } else {
        EmptyView()
      }
    }
  }
}

#if DEBUG
  struct ArticleContent_Previews: PreviewProvider {
    static var previews: some View {
      ArticleContentView(article: articleForPreview).environmentObject(
        articleContainerForPreview
      )
    }
  }
#endif
