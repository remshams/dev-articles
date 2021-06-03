//
//  BookmarkView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 04.04.21.
//

import SwiftUI

struct BookmarkView: View {
  let article: Article
  let size: CGFloat = 25
  @EnvironmentObject var model: ArticlesViewModel

  var body: some View {
    Button {
      withAnimation(.spring(response: 0.45, dampingFraction: article.bookmarked ? 0.825 : 0.45)) {
        model.toggleBookmark(article)
      }
    } label: {
      ZStack {
        Bookmark(bookmarked: article.bookmarked, size: size)
        BCircle(bookmarked: article.bookmarked)
      }
      .font(.system(size: size))
      .foregroundColor(.white)
    }
  }
}

struct Bookmark: View {
  let bookmarked: Bool
  let size: CGFloat

  var body: some View {
    Image(systemName: "bookmark.fill")
      .font(.system(size: size * 0.52))
      .colorMultiply(bookmarked ? .purple : .black)
  }
}

struct BCircle: View {
  let bookmarked: Bool

  var body: some View {
    Image(systemName: "circle")
      .colorMultiply(bookmarked ? .purple : .black)
      .overlay(
        Color.purple
          .opacity(0.15)
          .clipShape(Circle())
          .padding(3.5)
      )
      .scaleEffect(bookmarked ? 1 : 0)
  }
}

#if DEBUG
  struct Bookmark_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        BookmarkView(
          article: articleForPreview)
        BookmarkView(
          article: articleForPreview
        )
      }.previewLayout(.sizeThatFits)
    }
  }

#endif
