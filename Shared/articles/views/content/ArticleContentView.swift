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
          TagsView(tags: ["SwiftUI", "Swift", "JavaScript", "Rust"])
        }
      }.padding(.leading, 16)
    }
  }
}

private struct MetadataView: View {
  let metadata: ArticleMetaData

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ArticleStatsElement(iconName: "timer", value: "\(metadata.readingTime)", color: .gray)
      ArticleStatsElement(iconName: "icloud.and.arrow.up", value: metadata.publishedAt ?? Date(), color: .gray)
    }
  }
}

private struct CommunityDataView: View {
  let communityData: ArticleCommunityData

  var body: some View {
    VStack(spacing: 8) {
      ArticleStatsElement(iconName: "suit.heart.fill", value: "\(communityData.positiveReactionsCount)", color: .red)
      ArticleStatsElement(iconName: "text.bubble", value: "\(communityData.commentsCount)", color: .gray)
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
  let textColor: Color = [Color.orange, Color.red, Color.purple, Color.blue].randomElement()!

  var body: some View {
    Text("#\(tag)")
      .foregroundColor(textColor)
      .padding(4)
      .background(textColor.colorInvert())
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
        AsyncImage(url: url)
      } else {
        NoCoverImage()
      }
    }
  }
}

private struct NoCoverImage: View {
  var body: some View {
    Rectangle().foregroundColor(.gray)
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
