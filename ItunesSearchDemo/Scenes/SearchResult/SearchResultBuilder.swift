//
//  SearchResultBuilder.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/7.
//

import Foundation
import UIKit

final class SearchResultBuilder {
    
    class func buildViewController() -> UIViewController {
        
        let vc = SearchResultViewController.instantiate()
        vc.iTunesSearchAPI = DIContainer.shared.resolve()
        vc.musicDownloadHandler = DIContainer.shared.resolve()
        vc.avFoundationHandler = DIContainer.shared.resolve()
        
        let nav = UINavigationController(rootViewController: vc)
        
        return nav
    }
    
}
