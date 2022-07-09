//
//  ItunesSearchProvider.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/7.
//

import Foundation

enum iTunesSearchProvider {
    
    case search(query: String)
    
}

extension iTunesSearchProvider: Endpoint {
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }
    
    var params: [String : Any]? {
        switch self {
        case let .search(query):
            return ["term": query]
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    
}
