
import Foundation
import SwiftUI

struct ArticleView: View {
  let article: Article
  
  var body: some View {
    HStack {
      Text(article.title)
      Spacer()
      Link(destination: URL(string: "https://dev.to/allanloji/long-polling-with-react-query-7gl")!) {
        Image(systemName: "safari").font(.system(size: 25)).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
      }
    }.padding()
  }
}

#if DEBUG
struct ArticleView_Previews: PreviewProvider {
  static var previews: some View {
    ArticleView(article: Article(
                  title: "Short Title",
                  id: 0,
                  description: "Short title",
                  link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!)
    )
  }
}
#endif
