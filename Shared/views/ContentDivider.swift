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
      dividerContent.layoutPriority(1)
      Rectangle().fill(color).frame(height: 2)
    }
  }
}

#if DEBUG
  struct ContentDivider_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
        ContentDivider(color: .gray, dividerContent: Image(systemName: "person.fill"))
        ContentDivider(color: .gray, dividerContent: Text("Long sdfdsfdsfdsfsdfdsfdsfdssdfsdfdsafsdfdsfdsf"))
      }
    }
  }
#endif
