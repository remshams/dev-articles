import Foundation
import SwiftUI


struct ArticlesView: View {
  @EnvironmentObject var articlesEnvironment: ArticlesEnvironment
  
  var body: some View {
    ArticlesList(model: ArticlesViewModel(listArticle: articlesEnvironment.listArticle))
  }
}

struct ArticlesList: View {
  @ObservedObject var model: ArticlesViewModel
  
  init(model: ArticlesViewModel) {
    self.model = model
    model.loadArticles()
  }
  
  var body: some View {
    VStack {
      Text("Posts").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
      List(model.articles) { article in
        ArticleView(article: article)
      }
    }
    
  }
  
}

#if DEBUG
struct ArticlesView_Previews: PreviewProvider {
  static var previews: some View {
    ArticlesView().environmentObject(
      ArticlesEnvironment(
        listArticle: InMemoryArticlesDb(
          articles: [
            Article(
              title: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
              id: 0,
              description: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
              link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!),
            Article(
              title: "Other Article",
              id: 1,
              description: "Other Article",
              link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!)
          ])))
  }
}
#endif
