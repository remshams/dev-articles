//
//  File.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 24.07.21.
//

import Foundation
import SwiftUI

@main
struct AppView: App {
  let appContainer = AppContainer.shared

  var body: some Scene {
    WindowGroup {
      TabView {
        ArticlesView()
          .tabItem {
            Image(systemName: "book")
            Text("Articles")
          }
        ReadingListView()
          .tabItem {
            Image(systemName: "bookmark")
            Text("Readinglist")
          }
      }
      .environmentObject(appContainer.makeArticlesContainer())
      .environmentObject(appContainer.makeReadingListContainer())
      .environment(\.managedObjectContext, AppContainer.shared.context)
    }
  }
}
