//
//  iTunesSearchResponse.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/7.
//

import Foundation

struct iTunesSearchResponse: Decodable {
    
    let results: [iTunesSearchResult]
    
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}
