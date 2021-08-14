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
  @Environment(\.scenePhase) var scenePhase
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
      .environment(\.managedObjectContext, AppContainer.shared.persistence.context)
      .onChange(of: scenePhase) { newScenePhase in
        do {
          switch newScenePhase {
          case .active:
            return
          default:
            try appContainer.persistence.save()
          }
        } catch {
          fatalError("Saving of main core data context failed")
        }
      }
    }
  }
}
