
import Foundation
import SwiftUI

struct ArticleView: View {
  let article: Article
  
  var body: some View {
    HStack {
      Text(article.title)
      Spacer()
      Actions(link: article.link, bookmarked: article.bookmarked)
      
    }.padding()
  }
}

struct Actions: View {
  let link: URL
  let bookmarked: Bool
  
  var body: some View {
    HStack {
      Bookmark(bookmarked: bookmarked)
      Link(destination: link) {
        Image(systemName: "safari").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
      }
    }.font(.system(size: 25))
  }
}

struct Bookmark: View {
  let bookmarked: Bool
  @State var internalBookmarked = true
  
  var body: some View {
    Button(action: { withAnimation(.spring(response: 0.45, dampingFraction: internalBookmarked ? 0.825 : 0.45)) { internalBookmarked = !internalBookmarked } }) {
      ZStack {
        Image(systemName: "bookmark.fill")
          .font(.system(size: 13))
          .colorMultiply(internalBookmarked ? .purple : .black)
        Image(systemName: "circle")
          .font(.system(size: 25))
          .colorMultiply(internalBookmarked ? .purple : .black).scaleEffect(internalBookmarked ? 1 : 0)
      }.foregroundColor(.white)
    }
  }
}

#if DEBUG
struct ArticleView_Previews: PreviewProvider {
  static var previews: some View {
    ArticleView(article: Article(
                  title: "Short Title",
                  id: 0,
                  description: "Short title",
                  link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!, bookmarked: true )
    )
  }
}
#endif
