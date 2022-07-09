//
//  SearchResultViewModel.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/7.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchResultViewModel {
    
    private let searchResult: iTunesSearchResult
    
    var trackName: String?
    var artistName: String
    var artWorkURL: URL?
    
    var isPlaying: Bool = false
    
    var downloadState: DownloadState = .notDownloaded
    var index: Int?
    
    init(result: iTunesSearchResult) {
        self.searchResult = result
        
        self.trackName = result.trackName
        self.artistName = result.artistName
        self.artWorkURL = URL(string: result.artWorkURL)
    }
}

extension SearchResultViewModel: Asset {
    
    var assetName: String {
        return self.trackName ?? ""
    }
    
    var previewURL: String { return self.searchResult.previewURL }
}
