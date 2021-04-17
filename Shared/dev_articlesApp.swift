//
//  dev_articlesApp.swift
//  Shared
//
//  Created by Mathias Remshardt on 06.02.21.
//

import SwiftUI

@main
struct dev_articlesApp: App {
  
  let persistenceController = PersistenceController.shared
  let restClient: RestHttpClient
  let articleEnvironment: ArticlesEnvironment
  let readingListEnvironment: ReadingListEnvironment
  
  init() {
    restClient = RestHttpClient()
    let readingListRepository = ReadingListCoreDataRepository(managedObjectContext: persistenceController.container.viewContext)
    readingListEnvironment = ReadingListEnvironment(addReadingListItem: readingListRepository, listReadingListItem: readingListRepository)
    articleEnvironment = ArticlesEnvironment(listArticle: ArticlesRestAdapter(httpGet: restClient))
  }
  
  var body: some Scene {
    WindowGroup {
      ArticlesView()
        .environmentObject(articleEnvironment)
        .environmentObject(readingListEnvironment)
    }
  }
}
