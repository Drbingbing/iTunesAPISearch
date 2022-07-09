//
//  MusicDownloadHandlerProtocol.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/9.
//

import Foundation
import RxSwift

protocol Asset: AnyObject {
    
    var previewURL: String { get }
    
    var assetName: String { get }
    
    var downloadState: DownloadState { get set }
    
    var index: Int? { get set }
}

extension Asset {
    
    var downloadedPath: URL? {
        switch self.downloadState {
        case let .downloaded(destinationPath):
            return destinationPath
        default:
            return nil
        }
    }
}

enum DownloadState {
    
    case notDownloaded
    
    case downloading(progress: Float, totalSize: String)
    
    case downloaded(destinationPath: URL)
}

protocol MusicDownloadHandlerProtocol {
    
    var downloadCompletionSubject:  PublishSubject<Asset> { get }
    
    var downloadProgressSubject: PublishSubject<Asset> { get }
    
    func downloadMusic(for: Asset)
    
    func localMusicPath(withURL urlString: String) -> URL?
}
