//
//  SearchBar.swift
//  GithubSearcher
//
//  Created by Oleksii Salmin on 30.10.2020.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchQuery: String
    @State private var text: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(width: 16, height: 16, alignment: .center)
                .padding(.horizontal, 8)
            TextField("Search repo...", text: $text, onCommit: {
                searchQuery = text
            })
                .keyboardType(.webSearch)
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(.systemGray6))
        )
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchQuery: .constant("Lorem Ipsum"))
    }
}
