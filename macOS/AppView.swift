//
//  AppView.swift
//  dev-articles (macOS)
//
//  Created by Mathias Remshardt on 24.07.21.
//

import Foundation
import SwiftUI

@main
struct AppView: App {
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
