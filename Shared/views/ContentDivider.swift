//
//  TextDivider.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 13.06.21.
//

import SwiftUI

struct ContentDivider<Content: View>: View {
  let color: Color
  let dividerContent: Content

  var body: some View {
    HStack {
      Rectangle().fill(color).frame(height: 2)
      dividerContent
      Rectangle().fill(color).frame(height: 2)
    }
  }
}
