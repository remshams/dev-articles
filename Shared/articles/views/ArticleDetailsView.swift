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
      VStack(spacing: 0) {
        CoverImage().zIndex(1)
          .frame(height: gp.size.height * 1 / 3)
        Details()
      }.background(Color.gray.opacity(0.1))
    }
  }
}

private struct CoverImage: View {
  var body: some View {
    ZStack(alignment: .bottom) {
      Rectangle().foregroundColor(.purple)
      ProfileImage()
        .frame(width: 140, height: 140)
        .offset(CGSize(width: 0, height: 35))
    }
  }
}

private struct ProfileImage: View {
  var body: some View {
    Image("UserImage")
      .resizable()
      .clipShape(Circle())
      .overlay(Circle().stroke(lineWidth: 4).foregroundColor(.white))
  }
}

private struct Details: View {
  var body: some View {
    Rectangle().foregroundColor(.clear)
  }
}

#if DEBUG
  struct ArticleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      ArticleDetailsView(article: articleForPreview)
    }
  }
#endif
