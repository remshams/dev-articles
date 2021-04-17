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
  let persistenceController = PersistenceController.shared
  let restClient: RestHttpClient
  let readingListEnvironment: ReadingListEnvironment
  
  init() {
    appContainer = AppContainer()
    restClient = RestHttpClient()
    let readingListRepository = ReadingListCoreDataRepository(managedObjectContext: persistenceController.container.viewContext)
    readingListEnvironment = ReadingListEnvironment(addReadingListItem: readingListRepository, listReadingListItem: readingListRepository)
  }
  
  var body: some Scene {
    WindowGroup {
      ArticlesView()
        .environmentObject(appContainer.makeArticlesContainer())
        .environmentObject(readingListEnvironment)
    }
  }
}
