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
    NavigationView {
      VStack {
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
          NavigationLink(destination: ArticleContentView()) {
            ArticleView(article: article)
          }
        }
        .buttonStyle(BorderlessButtonStyle())
        .listStyle(InsetListStyle())
      }
      .padding(.top, 8)
      .navigationTitle("Posts")
      .navigationBarTitleDisplayMode(.automatic)
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
              articleForPreview,
              articleForPreview
            ]
          ),
          addReadingListItem: InMemoryReadingListRepository(readingListItems: [])
        )
      )
    }
  }
#endif
