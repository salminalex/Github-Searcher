//
//  ContentView.swift
//  GithubSeacher
//
//  Created by Oleksii Salmin on 30.10.2020.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var provider = RepoProvider()
    
    var body: some View {
        NavigationView {
            List() {
                Section() {
                    SearchBar(searchQuery: $provider.searchQuery)
                }
                Section() {
                    ForEach(provider.props.foundRepos) {
                        RepoRow(repo: $0)
                    }
                }
            }
            .alert(isPresented: $provider.props.showingError, content: {
                Alert(title: Text("Error"),
                      message: Text(provider.error?.localizedDescription ?? "Unknown error"),
                      dismissButton: .default(Text("Ok")))
            })
            .listStyle(PlainListStyle())
            .navigationTitle("Search")
            .navigationBarItems(trailing: ActivityIndicator(isAnimating: $provider.props.loading))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
