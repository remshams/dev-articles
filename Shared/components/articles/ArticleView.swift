
import Foundation
import SwiftUI

struct ArticleView: View {
  let article: Article
  
  var body: some View {
    HStack {
      Text(article.title)
    }.padding()
  }
}

#if DEBUG
struct ArticleView_Previews: PreviewProvider {
  static var previews: some View {
    ArticleView(article: Article(
                  title: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
                  id: 0,
                  description: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
                  published: false)
    )
  }
}
#endif
