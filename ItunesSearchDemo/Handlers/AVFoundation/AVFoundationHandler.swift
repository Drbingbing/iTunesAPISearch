//
//  AVFoundationHandler.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/9.
//

import Foundation
import RxSwift
import AVFoundation
import MediaPlayer

protocol AVFoundationHandlerProtocol {
    
    var playerSubject: PublishSubject<Asset> { get }
    
    func active()
    
    mutating func startPlaying(for asset: Asset)
    
    mutating func stopPlaying()
}

final class AVFoundationHandler: AVFoundationHandlerProtocol {
    
    private let player: AVPlayer = AVPlayer()
    private var isNowPlaying: PlayerItem?
    
    let playerSubject = PublishSubject<Asset>()
    
    func active() {
        
        self.setupAudioOutput()
        self.setupRemoteTransportControls()
        
    }
    
    func startPlaying(for asset: Asset) {
        guard let musicPath = asset.downloadedPath else { return }
        
        if let isNowPlaying = isNowPlaying,
           isNowPlaying.asset.downloadedPath == musicPath {
            self.player.play()
            return
        }
        
        if let currentPlayed = isNowPlaying {
            self.playerSubject.onNext(currentPlayed.asset)
        }
        
        let playerItem = PlayerItem(asset: asset, playerItem: AVPlayerItem(url: musicPath))
        self.setNowPlaying(for: playerItem)
        self.isNowPlaying = playerItem
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else { return }
            self.playerSubject.onNext(asset)
            
            self.player.replaceCurrentItem(with: nil)
            self.isNowPlaying = nil
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        }
        
    }
    
    func stopPlaying() {
        self.player.pause()
    }
    
    private func setNowPlaying(for item: PlayerItem) {
        
        var nowPlayingInfo = [String : Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = item.asset.assetName
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = item.playerItem.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = item.playerItem.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        player.replaceCurrentItem(with: item.playerItem)
        player.play()
    }
    
    private func setupAudioOutput() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] event in
                if self.player.rate == 0.0 {
                    self.player.play()
                    return .success
                }
                return .commandFailed
            }

        commandCenter.pauseCommand.addTarget { [unowned self] event in
                if self.player.rate == 1.0 {
                    self.player.pause()
                    return .success
                }
                return .commandFailed
            }
    }
}
