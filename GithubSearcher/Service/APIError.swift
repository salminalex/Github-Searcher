//
//  APIError.swift
//  GithubSearcher
//
//  Created by Oleksii Salmin on 30.10.2020.
//

import Foundation

enum APIError: LocalizedError {
    
    case forbidden
    case appNetworkingError
    case internalServer
    case unknown
    
    init?(statusCode: Int) {
        switch statusCode {
        case 200...399:
            return nil
        case 403:
            self = .forbidden
        case 400...499:
            self = .appNetworkingError
        case 500...511:
            self = .appNetworkingError
        default:
            self = .unknown
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .forbidden:
            return "Forbidden"
        case .appNetworkingError:
            return "Some app networking error."
        case .internalServer:
            return "Internal server error."
        case .unknown:
            return "Unknown API error."
        }
    }
}
