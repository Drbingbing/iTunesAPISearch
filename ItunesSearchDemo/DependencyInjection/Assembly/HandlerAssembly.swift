//
//  HandlerAssembly.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/8.
//

import Foundation
import Swinject

final class HandlerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MusicDownloadHandlerProtocol.self) { _ in
            return MusicDownloadHandler()
        }
        .inObjectScope(.container)
        
        container.register(AVFoundationHandlerProtocol.self) { _ in
            return AVFoundationHandler()
        }
        .inObjectScope(.container)
    }
}
