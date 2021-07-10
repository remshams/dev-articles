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

struct Actions: View {
  let article: Article

  var body: some View {
    HStack {
      BookmarkView(article: article)
      ArticleDetailsIcon(article: article)
      Link(destination: article.metaData.link) {
        Image(systemName: "safari")
      }.font(.system(size: 25))
    }
  }
}

private struct ArticleDetailsIcon: View {
  let article: Article
  @State var showDetails = false

  var body: some View {
    Button { showDetails.toggle() }
    label: {
      Image(systemName: "info.circle")
        .font(.system(size: 25))
    }.sheet(isPresented: $showDetails) {
      ArticleDetailsView(article: article)
    }
  }
}

#if DEBUG
  struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
      ArticleView(article: articleForPreview)
    }
  }
#endif
