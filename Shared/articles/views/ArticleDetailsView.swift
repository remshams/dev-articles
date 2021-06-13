//
//  ArticleDetailsView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 29.05.21.
//

import Foundation
import SwiftUI

struct ArticleDetailsView: View {
  let article: Article

  var body: some View {
    GeometryReader { gp in
      VStack(spacing: 16) {
        Text(article.title).font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
        CoverImage(url: article.metaData.coverImageUrl).zIndex(1)
          .frame(height: gp.size.height * 1 / 3)
        Author().padding(.leading, 8).padding(.trailing, 8)
        Tags(tags: ["SwiftUI", "Swift", "JavaScript", "Rust"])
        Stats(article: article)
      }
    }
  }
}

private struct CoverImage: View {
  let url: URL?

  var body: some View {
    Group {
      if let url = url {
        AsyncImage(url: url)
      } else {
        Image("UserImage").resizable()
      }
    }
  }
}

private struct Author: View {
  var body: some View {
    HStack {
      AuthorImage().frame(width: 40, height: 40)
      AuthorDetails()
    }
  }
}

private struct AuthorImage: View {
  var body: some View {
    Image("UserImage")
      .resizable()
      .clipShape(Circle())
  }
}

private struct AuthorDetails: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("Mathias Remshardt").fontWeight(.bold)
      Text("1 Juli (5 days ago)")
    }.font(.subheadline).foregroundColor(.cardSecondaryColor)
  }
}

private struct Stats: View {
  let article: Article

  var body: some View {
    HStack {
      ContentDivider(
        color: .gray,
        dividerContent: Image(systemName: "chart.bar.fill").foregroundColor(.purple).font(.system(size: 25))
      )
    }.padding(.leading, 4).padding(.trailing, 4)
    LazyHGrid(rows: Array(repeating: .init(.flexible()), count: 2), spacing: 32) {
      StatsElement(iconName: "timer", value: "\(article.metaData.readingTime)", color: .gray)
        .frame(maxWidth: .infinity, alignment: .leading)
      StatsElement(iconName: "icloud.and.arrow.up", value: article.metaData.publishedAt ?? Date(), color: .gray)
      StatsElement(iconName: "suit.heart.fill", value: "\(article.communityData.positiveReactionsCount)", color: .red)
      StatsElement(iconName: "text.bubble", value: "\(article.communityData.commentsCount)", color: .gray)
    }
  }
}

private struct StatsElement: View {
  let iconName: String
  let value: Text
  let color: Color

  init(iconName: String, value: Text, color: Color) {
    self.iconName = iconName
    self.value = value
    self.color = color
  }

  init(iconName: String, value: String, color: Color) {
    self.init(iconName: iconName, value: Text(value), color: color)
  }

  init(iconName: String, value: Date, color: Color) {
    self.init(iconName: iconName, value: Text(value, style: .date), color: color)
  }

  var body: some View {
    HStack {
      Image(systemName: iconName).foregroundColor(color)
      value
    }
  }
}

private struct Tags: View {
  let tags: [String]

  var body: some View {
    HStack {
      ForEach(tags, id: \.self) {
        Tag(tag: $0)
      }
    }
  }
}

private struct Tag: View {
  let tag: String
  let textColor: Color = [Color.orange, Color.red, Color.purple, Color.blue].randomElement()!

  var body: some View {
    Text("#\(tag)")
      .foregroundColor(textColor)
      .padding(4)
      .scaledToFit()
      .background(textColor.colorInvert())
      .cornerRadius(5)
  }
}

#if DEBUG
  struct ArticleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        ArticleDetailsView(article: articleForPreview)
        ArticleDetailsView(article: articleForPreview).previewLayout(.fixed(width: 1024, height: 768))
      }
    }
  }
#endif
