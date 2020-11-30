//
//  RepoModel.swift
//  GithubSearcher
//
//  Created by Oleksii Salmin on 30.10.2020.
//

import Foundation

struct RepoModel: Codable, Identifiable {
    let id: Int
    let name: String
    let html_url: String?
    let description: String?
}
