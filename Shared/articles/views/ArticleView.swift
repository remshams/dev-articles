
import Foundation
import SwiftUI

struct ArticleView: View {
  let article: Article
  
  var body: some View {
    HStack {
      Text(article.title)
      Spacer()
      Actions(article: article)
      
    }.padding()
  }
}

struct Actions: View {
  let article: Article
  
  var body: some View {
    HStack {
      BookmarkView(article: article)
      Link(destination: article.link) {
        Image(systemName: "safari").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
      }.font(.system(size: 25))
    }
  }
}

#if DEBUG
struct ArticleView_Previews: PreviewProvider {
  static var previews: some View {
    ArticleView(article: Article(
                  title: "Short Title",
                  id: "0",
                  description: "Short title",
                  link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!, bookmarked: true)
    )
  }
}
#endif
