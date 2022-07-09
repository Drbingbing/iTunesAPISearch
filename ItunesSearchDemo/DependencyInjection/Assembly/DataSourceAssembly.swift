//
//  RemoteDataSource.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/7.
//

import Foundation
import Swinject

final class DataSourceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(NetworkDependencyProtocol.self) { _ in
            NetworkDependency()
        }
        
        container.register(iTunesSearchAPIProtocol.self) { resolver in
            guard let networkDependency = resolver.resolve(NetworkDependencyProtocol.self) else {
                fatalError("NetworkDependencyProtocol dependency could not be resolved")
            }
            
            return iTunesSearchAPI(dependency: networkDependency)
        }
    }
}
