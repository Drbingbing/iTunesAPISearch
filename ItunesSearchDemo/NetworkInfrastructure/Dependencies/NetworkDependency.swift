//
//  NetworkDependency.swift
//  CombineDemo
//
//  Created by Bing Bing on 2022/6/30.
//

import Foundation
import RxSwift

final class NetworkDependency: NetworkDependencyProtocol {
    let backgroundWorkScheduler: ImmediateSchedulerType
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        operationQueue.qualityOfService = QualityOfService.userInitiated
        self.backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
    }
    
    convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        self.init(configuration: configuration)
    }
}
