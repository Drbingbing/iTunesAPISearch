//
//  NetworkDependency.swift
//  CombineDemo
//
//  Created by Bing Bing on 2022/6/30.
//

import Foundation
import RxSwift

protocol NetworkDependencyProtocol {
    
    var session: URLSession { get }
    
    var backgroundWorkScheduler: ImmediateSchedulerType { get }
    
    var mainScheduler: SerialDispatchQueueScheduler { get }
}

extension NetworkDependencyProtocol {
    
    var mainScheduler: SerialDispatchQueueScheduler {
        return MainScheduler.instance
    }
}
