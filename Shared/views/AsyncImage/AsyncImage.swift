//
//  AsyncImage.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 06.06.21.
//

import Combine
import Foundation
import SwiftUI

struct AsyncImage: View {
  let url: URL

  var body: some View {
    AsyncView(source: RestHttpClient().get(for: url)) {
      if let image = UIImage(data: $0) {
        Image(uiImage: image).resizable()
      } else {
        Text("Loading Failed")
      }
    }
  }
}
