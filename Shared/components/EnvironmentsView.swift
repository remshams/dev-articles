//
//  Environments.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 20.02.21.
//

import Foundation
import SwiftUI

struct EnvironmentsView: View {
  //  let articleEnvironment = ArticlesEnvironment(listArticle: InMemoryArticlesDb(
  //                                                articles: [
  //                                                  Article(
  //                                                    title: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
  //                                                    id: 0,
  //                                                    description: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
  //                                                    link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!),
  //                                                  Article(
  //                                                    title: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
  //                                                    id: 0,
  //                                                    description: "Rolling (up) a multi module system (esm, cjs...) compatible npm library with TypeScript and Babel",
  //                                                    link: URL(string: "https://dev.to/remshams/rolling-up-a-multi-module-system-esm-cjs-compatible-npm-library-with-typescript-and-babel-3gjg")!)
  //                                                ]))
  
  let persistenceController = PersistenceController.shared
  let restClient: RestHttpClient
  let articleEnvironment: ArticlesEnvironment
  
  init() {
    restClient = RestHttpClient()
    articleEnvironment = ArticlesEnvironment(listArticle: ArticlesRestAdapter(httpGet: restClient))
  }
  
  var body: some View {
    ArticlesView()
      .environment(\.managedObjectContext, persistenceController.container.viewContext)
      .environmentObject(articleEnvironment)
  }
}
