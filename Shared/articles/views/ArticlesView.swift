import Combine
import Foundation
import SwiftUI

struct ArticlesView: View {
  @EnvironmentObject var articlesContainer: ArticlesContainer
  @EnvironmentObject var readingListContainer: ReadingListContainer

  var body: some View {
    ArticlesList(
      model: articlesContainer.makeArticlesViewModel()
    )
  }
}

struct ArticlesList: View {
  @ObservedObject var model: ArticlesViewModel
  @EnvironmentObject var articlesContainer: ArticlesContainer
  @State var articles: [Article] = []
  @State var timeCategory: TimeCategory = .feed

  var cancellables = Set<AnyCancellable>()

  init(model: ArticlesViewModel) {
    self.model = model
  }

  var body: some View {
    VStack {
      Text("Posts").font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
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
    }
    .onAppear {
      model.loadArticles()
    }
    .environmentObject(model)
  }
}

#if DEBUG
  struct ArticlesView_Previews: PreviewProvider {
    static var previews: some View {
      ArticlesView().environmentObject(
        ArticlesContainer(
          listArticle: InMemoryArticlesRepository(
            articles: [
              Article(
                // swiftlint:disable:next line_length
                title: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
                id: "0",
                // swiftlint:disable:next line_length
                description: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
                link: URL(
                  string: "https://www.google.de"
                )!,
                coverImage: URL(string: "https://www.google.de")!
              ),
              Article(
                title: "Other Article",
                id: "1",
                description: "Other Article",
                link: URL(
                  string: "https://www.google.de"
                )!,
                coverImage: URL(string: "https://www.google.de")!
              )
            ]
          ),
          addReadingListItem: InMemoryReadingListRepository(readingListItems: [])
        )
      )
    }
  }
#endif
