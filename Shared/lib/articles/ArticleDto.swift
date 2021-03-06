//
//  ArticleDto.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 06.03.21.
//

struct ArticleDto: Identifiable, Decodable {
  let id: Int
  let title: String
  let description: String
  let url: String
  
}
