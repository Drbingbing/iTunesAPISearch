//
//  Endpoint.swift
//  InterviewDemo
//
//  Created by Bing Bing on 2022/6/30.
//

import Foundation


protocol Endpoint {
    
    var path: String { get }
    
    var params: [String: Any]? { get }
    
    var method: HttpMethod { get }
}


enum HttpMethod: String {
    case get = "GET"
}

extension Endpoint {
    
    private var scheme: String {
        return "https"
    }

    private var host: String {
        return "itunes.apple.com"
    }
    
    var urlComponent: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        
        components.path = path
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "media", value: "music")
        ]
        
        if let params = params, method == .get {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0, value: "\($1)") })
        }
        
        components.queryItems = queryItems
        
        return components
    }
    
    var request: URLRequest {
        
        let url = urlComponent.url!
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        return request
    }
}
