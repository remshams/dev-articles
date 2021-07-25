//
//  ArticleCard.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 25.07.21.
//

import Foundation
import SwiftUI

struct ArticleCardView: View {
  let article: Article

  var body: some View {
    HStack {
      Text("Article Title").foregroundColor(.gray)
      Text(article.title)
    }
  }
}

#if DEBUG
  struct ArticleCardView_Previews: PreviewProvider {
    static var previews: some View {
      ArticleCardView(article: articleForPreview)
    }
  }
#endif
