//
//  RepoProvider.swift
//  GithubSearcher
//
//  Created by Oleksii Salmin on 30.10.2020.
//

import Foundation
import SwiftUI
import Combine

class RepoProvider: ObservableObject {
    
    struct Props {
        var foundRepos: [RepoModel]
        var loading: Bool
        var showingError: Bool
    }
    
    @Published var props: Props = Props(foundRepos: [], loading: false, showingError: false)
    @Published var searchQuery: String = ""
    private(set) var error: Error?
    private var cancellable = Set<AnyCancellable>()
    
    //MARK: - Settings
    private let itemsPerRequest = 15
    
    init() {
        $searchQuery
            .sink(receiveValue: { [weak self] in self?.searchFor(query: $0) })
            .store(in: &cancellable)
    }
    
    private func searchFor(query: String) {
        guard !query.isEmpty else {
            props.foundRepos = []
            return
        }
        props.loading = true
        
        Publishers.Zip(
            publisherFor(query: query, page: 0),
            publisherFor(query: query, page: 1)
        )
        .sink(receiveCompletion: { [weak self] completion in
            if case let .failure(error) = completion {
                self?.error = error
                self?.props.showingError = true
                self?.props.loading = false
            }
        },
        receiveValue: { [weak self] response in
            self?.props.foundRepos = response.0.items + response.1.items
            self?.props.loading = false
        })
        .store(in: &cancellable)
    }
    
    private func publisherFor(query: String, page: Int) -> AnyPublisher<ResponseModel, Error> {
        var components = URLComponents(string: "https://api.github.com/search/repositories")!
        components.queryItems = [
            URLQueryItem(name: "q", value: String(query)),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "per_page", value: String(itemsPerRequest)),
            URLQueryItem(name: "page", value: String(page)),
        ]
        var request = URLRequest(url: components.url!)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap({ element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
                if let error = APIError(statusCode: httpResponse.statusCode) {
                    throw error
                } else {
                    return element.data
                }
            })
            .decode(type: ResponseModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        return task
    }
}
