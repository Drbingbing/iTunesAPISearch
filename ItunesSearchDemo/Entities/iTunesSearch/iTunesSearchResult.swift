//
//  ItunesSearchResult.swift
//  ItunesSearchDemo
//
//  Created by Bing Bing on 2022/7/7.
//

import Foundation

struct iTunesSearchResult: Decodable {
    
    let trackName: String?
    let artistName: String
    let artWorkURL: String
    let previewURL: String
    
    private enum CodingKeys: String, CodingKey {
        case trackName = "trackName"
        case artistName = "artistName"
        case artWorkURL = "artworkUrl60"
        case previewURL = "previewUrl"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        trackName = try? values.decode(String.self, forKey: .trackName)
        artistName = try values.decode(String.self, forKey: .artistName)
        artWorkURL = try values.decode(String.self, forKey: .artWorkURL)
        previewURL = try values.decode(String.self, forKey: .previewURL)
    }
}
