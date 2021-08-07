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
      ArticleView(article: articleForPreview)
    }
  }
#endif
