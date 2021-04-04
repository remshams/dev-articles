
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
      Bookmark(article: article)
      Link(destination: article.link) {
        Image(systemName: "safari").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
      }
    }.font(.system(size: 25))
  }
}

struct Bookmark: View {
  let article: Article
  @EnvironmentObject var model: ArticlesViewModel
  
  var body: some View {
    Button(action: { withAnimation(.spring(response: 0.45, dampingFraction: article.bookmarked ? 0.825 : 0.45)) { model.toggleBookmark(article) } }) {
      ZStack {
        Image(systemName: "bookmark.fill")
          .font(.system(size: 13))
          .colorMultiply(article.bookmarked ? .purple : .black)
        Image(systemName: "circle")
          .font(.system(size: 25))
          .colorMultiply(article.bookmarked ? .purple : .black)
          .overlay(
            Color.purple
              .opacity(0.15)
              .clipShape(Circle())
              .padding(3.5)
          )
          .scaleEffect(article.bookmarked ? 1 : 0)
        
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
                  link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!, bookmarked: true)
    )
  }
}
#endif
