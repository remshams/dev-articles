//
//  ArticleStatsView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 11.07.21.
//

import Foundation
import SwiftUI

struct ArticleStatsElement: View {
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
      Spacer()
      value
    }
  }
}


#if DEBUG
struct ArticleStatsElement_Previews: PreviewProvider {
  static var previews: some View {
    VStack(alignment: .leading) {
      ArticleStatsElement(iconName: "suit.heart.fill", value: Text("12"), color: .red)
      ArticleStatsElement(iconName: "text.bubble", value: Text("4"), color: .gray)
    }
  }
}
#endif
