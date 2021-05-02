//
//  ArticlesUseCase.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 02.05.21.
//

import Foundation

protocol ArticlesUseCaseFactory {
  func makeLoadArticlesUseCase(timeCategory: TimeCategory) -> LoadArticlesUseCase
}
