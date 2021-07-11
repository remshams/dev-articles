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
      value
    }
  }
}
