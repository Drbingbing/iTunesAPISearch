//
//  APIClient.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/7.
//

import Foundation
import RxCocoa
import RxSwift

protocol APIClient {
    
    var dependency: NetworkDependencyProtocol { get }
    
    func fetch<T: Decodable>(request: URLRequest) -> Observable<T>
}


extension APIClient {
    
    
    func fetch<T: Decodable>(request: URLRequest) -> Observable<T> {
        return dependency.session
            .rx
            .data(request: request)
            .observe(on: dependency.backgroundWorkScheduler)
            .decode(type: T.self, decoder: JSONDecoder())
            .observe(on: dependency.mainScheduler)
    }
    
}
