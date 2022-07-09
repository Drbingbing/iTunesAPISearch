//
//  DIContainer.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/7.
//

import Foundation
import Swinject

final class DIContainer {
    
    static let shared = DIContainer()
    
    private let container = Container()
    private let assembler: Assembler
    
    private init() {
        let assembly: [Assembly] = [
            DataSourceAssembly(),
            HandlerAssembly()
        ]
        
        self.assembler = Assembler(assembly, container: container)
    }
    
    func resolve<T>() -> T {
        guard let dependency = self.container.resolve(T.self) else {
            fatalError("\(T.self) dependency could not resolved")
        }
        
        return dependency
    }
}
