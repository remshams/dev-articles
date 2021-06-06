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
        HStack {
          Author()
          ReadingDetails(article: article)
        }.padding(.leading, 8).padding(.trailing, 8)
        Tags(tags: ["SwiftUI", "Swift", "JavaScript", "Rust"])
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
      Spacer()
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

private struct ReadingDetails: View {
  let article: Article

  var body: some View {
    Text("\(article.metaData.readingTime) min read").font(.subheadline).foregroundColor(.cardSecondaryColor)
  }
}

private struct Tags: View {
  let tags: [String]

  var body: some View {
    HStack {
      ForEach(tags, id: \.self) {
        Spacer()
        Tag(tag: $0)
        Spacer()
      }
    }
  }
}

private struct Tag: View {
  let tag: String

  var body: some View {
    Text("#\(tag)")
      .padding(4)
      .scaledToFit()
      .background(Color(red: .random(in: 0 ... 1), green: .random(in: 0 ... 1), blue: .random(in: 0 ... 1)))
      .cornerRadius(5)
  }
}

#if DEBUG
  struct ArticleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      ArticleDetailsView(article: articleForPreview)
    }
  }
#endif
