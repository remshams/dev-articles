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
    HStack {
      Text(article.title)
    }
  }
}
