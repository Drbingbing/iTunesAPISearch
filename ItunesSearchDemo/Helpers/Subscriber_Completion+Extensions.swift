//
//  Subscriber_Completion+Extension.swift
//  MovieTheater
//
//  Created by Bing Bing on 2022/7/6.
//

import Combine


extension Subscribers.Completion {
    
    var error: Error? {
        if case let .failure(e) = self {
            return e
        }
        
        return nil
    }
    
}
