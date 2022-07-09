//
//  MusicDownloadHandler.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/8.
//

import Foundation
import RxSwift
import RxCocoa

final class MusicDownloadHandler: NSObject, MusicDownloadHandlerProtocol {
    
    private var activeDownloadMap: [URLSessionDownloadTask: Asset] = [:]
    
    private var session: URLSession!
    
    private var documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    
    let downloadCompletionSubject = PublishSubject<Asset>()
    let downloadProgressSubject = PublishSubject<Asset>()
    
    override init() {
        super.init()
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "Music-Donwloader")
        self.session = URLSession(configuration: backgroundConfiguration, delegate: self, delegateQueue: .main)
    }
    
    
    func downloadMusic(for asset: Asset) {
        guard let url = URL(string: asset.previewURL) else { return }

        let task = session.downloadTask(with: url)

        activeDownloadMap[task] = asset

        task.resume()
        asset.downloadState = .downloading(progress: 0, totalSize: "")
    }
    
    func localMusicPath(withURL urlString: String) -> URL? {
        if let url = URL(string: urlString) {
            let localPath = localFilePath(for: url)
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: localPath.path) {
                return localPath
            }
        }
        
        return nil
    }
}

extension MusicDownloadHandler: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            downloadCompletionSubject.onError(error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let asset = self.activeDownloadMap[downloadTask] else { return }
        
        guard let sourceURL = URL(string: asset.previewURL) else {
            return
        }
        let destinationURL = localFilePath(for: sourceURL)
        activeDownloadMap[downloadTask] = nil
        
        let fileManager = FileManager.default
        
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            
            asset.downloadState = .downloaded(destinationPath: destinationURL)
            
            downloadCompletionSubject.onNext(asset)
        } catch {
            downloadCompletionSubject.onError(error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let asset = activeDownloadMap[downloadTask] else { return }
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        
        asset.downloadState = .downloading(progress: progress, totalSize: totalSize)
        
        downloadProgressSubject.onNext(asset)
    }
    
    private func localFilePath(for url: URL) -> URL {
        return documentPath.appendingPathComponent(url.lastPathComponent)
    }
}
