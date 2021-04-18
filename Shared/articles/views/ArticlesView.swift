import Foundation
import SwiftUI

struct ArticlesView: View {
  @EnvironmentObject var articlesEnvironment: ArticlesContainer
  @EnvironmentObject var readingListEnvironment: ReadingListContainer
  
  var body: some View {
    ArticlesList(
      model: ArticlesViewModel(listArticle: articlesEnvironment.listArticle,
                               addReadingListItem: readingListEnvironment.addReadingListItem
      ))
  }
}

struct ArticlesList: View {
  @ObservedObject var model: ArticlesViewModel
  
  init(model: ArticlesViewModel) {
    self.model = model
  }
  
  var body: some View {
    VStack {
      Text("Posts").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
      Picker("Select a time category", selection: $model.selectedTimeCategory) {
        Text("Feed").tag(TimeCategory.feed)
        Text("Day").tag(TimeCategory.day)
        Text("Week").tag(TimeCategory.week)
        Text("Month").tag(TimeCategory.month)
        Text("Year").tag(TimeCategory.year)
      }
      .padding(.leading, 10)
      .padding(.trailing, 10)
      .pickerStyle(SegmentedPickerStyle())
      List(model.articles) { article in
        ArticleView(article: article)
      }.buttonStyle(PlainButtonStyle())
    }.environmentObject(model)
    
  }
  
}

#if DEBUG
struct ArticlesView_Previews: PreviewProvider {
  static var previews: some View {
    ArticlesView().environmentObject(
      ArticlesContainer(
        listArticle: ArticlesInMemoryRepository(
          articles: [
            Article(
              title: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
              id: "0",
              description: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
              link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!),
            Article(
              title: "Other Article",
              id: "1",
              description: "Other Article",
              link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!)
          ]),
        addReadingListItem: ReadingListInMemoryRepository(readingListItems: [])))
  }
}
#endif
