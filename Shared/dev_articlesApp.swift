//
//  dev_articlesApp.swift
//  Shared
//
//  Created by Mathias Remshardt on 06.02.21.
//

import SwiftUI

@main
struct dev_articlesApp: App {
  
  let appContainer: AppContainer
  
  init() {
    appContainer = AppContainer()
  }
  
  var body: some Scene {
    WindowGroup {
      ArticlesView()
        .environmentObject(appContainer.makeArticlesContainer())
        .environmentObject(appContainer.makeReadingListContainer())
    }
  }
}
