//
//  APIClientError.swift
//  MovieTheater
//
//  Created by Bing Bing on 2022/7/5.
//

import Foundation

enum APIClientError: Error {
    
    case nonHTTPResponse(response: URLResponse)
    
    case httpRequestFailed(response: HTTPURLResponse, data: Data?)
    
    case decodeError(error: Error)
    
    case deserializationError(error: Swift.Error)
}

extension APIClientError: CustomDebugStringConvertible, LocalizedError {
    
    var errorDescription: String? {
        return debugDescription
    }
    
    var debugDescription: String {
        switch self {
        case let .nonHTTPResponse(response):
            return "Response is not NSHTTPURLResponse `\(response)`."
        case let .httpRequestFailed(response, _):
            return "HTTP request failed with `\(response.statusCode)`."
        case let .decodeError(error):
            return "Decode Json failed with `\(error.localizedDescription)`"
        case let .deserializationError(error):
            return "Error during deserialization of the response: \(error)"
        }
    }
}
