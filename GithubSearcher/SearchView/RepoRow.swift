//
//  RepoRow.swift
//  GithubSearcher
//
//  Created by Oleksii Salmin on 30.10.2020.
//

import SwiftUI

struct RepoRow: View {
    
    let repo: RepoModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(repo.name)
                    .font(.body)
                if let description = repo.description {
                    Text(description)
                        .font(.subheadline)
                }
            }
            Spacer()
            if let repoURLString = repo.html_url, let repoUrl = URL(string: repoURLString) {
                Button("Open") { UIApplication.shared.open(repoUrl) }
            }
        }
    }
}

struct RepoRow_Previews: PreviewProvider {
    static var previews: some View {
        RepoRow(repo: RepoModel(id: 0, name: "Lorem Ipsum", html_url: nil, description: nil))
    }
}
