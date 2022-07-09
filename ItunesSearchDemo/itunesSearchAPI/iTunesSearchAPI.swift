//
//  ItunesSearchAPI.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/7.
//

import Foundation
import RxSwift

protocol iTunesSearchAPIProtocol {
    
    func search(query: String) -> Observable<iTunesSearchResponse>
}


final class iTunesSearchAPI: APIClient, iTunesSearchAPIProtocol {
    
    let dependency: NetworkDependencyProtocol
    
    init(dependency: NetworkDependencyProtocol) {
        self.dependency = dependency
    }
    
    
    func search(query: String) -> Observable<iTunesSearchResponse> {
        let request = iTunesSearchProvider.search(query: query).request
        
        return fetch(request: request)
    }
}
