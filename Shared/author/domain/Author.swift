//
//  Author.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 13.07.21.
//

import Foundation

struct Author: Equatable {
  let username: String
  let name: String
  let image: URL
}

#if DEBUG
  // swiftlint:disable line_length
  let authorForPreview = Author(
    username: "testusername",
    name: "testuser",
    image: URL(
      string: "https://res.cloudinary.com/practicaldev/image/fetch/s--HLgRIqge--/c_fill,f_auto,fl_progressive,h_90,q_auto,w_90/https://dev-to-uploads.s3.amazonaws.com/uploads/user/profile_image/454589/8ef04500-1a36-45ce-817d-fa20094c11b3.jpeg"
    )!
  )
  // swiftlint:enable line_length
#endif
