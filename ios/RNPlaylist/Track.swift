//
//  Track.swift
//  Playlist
//
//  Created by Alex Stokes on 2/24/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

class Track {
    let id: String
    let url: MediaURL?
    
    @objc var title: String
    @objc var artist: String
    @objc var album: String?

    var artwork: MediaURL?
    var date: String?
    var desc: String?
    var genre: String?
    var duration: Double?
    var skipped: Bool = false
    
    private var originalObject: [String: Any]
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String,
            let artist = dictionary["artist"] as? String,
            let url = MediaURL(object: dictionary["url"]),
            let artwork = MediaURL(object: dictionary["artwork"])
            else { return nil }
        
        self.id = id
        self.url = url
        self.title = title
        self.artist = artist
        self.artwork = artwork
        
        self.date = dictionary["date"] as? String
        self.album = dictionary["album"] as? String
        self.genre = dictionary["genre"] as? String
        self.desc = dictionary["description"] as? String
        self.duration = dictionary["duration"] as? Double
        
        self.originalObject = dictionary
    }
    
    
    // MARK: - Public Interface
    
    func toObject() -> [String: Any] {
        return originalObject
    }
    
    func updateMetadata(dictionary: [String: Any]) {
        self.title = (dictionary["title"] as? String) ?? self.title
        self.artist = (dictionary["artist"] as? String) ?? self.artist
        self.artwork = (dictionary["artwork"] as? MediaURL) ?? self.artwork
            
        self.date = dictionary["date"] as? String
        self.album = dictionary["album"] as? String
        self.genre = dictionary["genre"] as? String
        self.desc = dictionary["description"] as? String
        self.duration = dictionary["duration"] as? Double
        
        self.originalObject = self.originalObject.merging(dictionary) { (_, new) in new }
    }
    
    // MARK: - AudioItem Protocol
    
    func getSourceUrl() -> String {
        return url?.value.absoluteString ?? ""
    }
    
    func getArtist() -> String? {
        return artist
    }
    
    func getTitle() -> String? {
        return title
    }
    
    func getAlbumTitle() -> String? {
        return album
    }
    
//    func getSourceType() -> SourceType {
//        return url.isLocal ? .file : .stream
//    }
    
//    func getArtwork(_ handler: @escaping (UIImage?) -> Void) {
//        if let artworkURL = artworkURL?.value {
//            URLSession.shared.dataTask(with: artworkURL, completionHandler: { (data, _, error) in
//                if let data = data, let artwork = UIImage(data: data), error == nil {
//                    handler(artwork)
//                }
//
//                handler(nil)
//            }).resume()
//        }
//
//        handler(nil)
//    }

}
