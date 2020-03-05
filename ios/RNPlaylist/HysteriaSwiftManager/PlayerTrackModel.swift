//
//  SwiftPlayerModel.swift
//  Pods
//
//  Created by iTSangar on 1/20/16.
//
//

import Foundation

enum TrackType {
  case normal
  case next
}

public struct PlayerTrack {
  public let url: String!
  public let name: String?
  public let image: String?
  public let album: Album?
  public let artist: Artist?
  public let custom: NSDictionary?
  public var dictionary: [String: Any] {
    return [
      "url": url as? Any,
      "name": name as? Any,
      "image": image as? Any,
      "album": album?.name as? Any,
      "artist": artist?.name as? Any,
      "custom": custom as? Any,
      "origin": origin as? Any,
      "position": position as? Any
    ]
  }
    
  var origin: TrackType! = TrackType.normal
  var position: Int?
  
  public struct Album {
    public var name: String?
    
    public init() { }
    
    public init(name: String?) {
      self.name = name
    }
  }
  
  public struct Artist {
    public var name: String?
    
    public init() { }
    
    public init(name: String?) {
      self.name = name
    }
  }
  
  public init(url: String, name: String? = nil, image: String? = nil, album: String? = nil, artist: String? = nil, custom: NSDictionary?) {
    self.url = url
    self.name = name
    self.image = image
    self.album = Album(name: album)
    self.artist = Artist(name: artist)
    self.custom = custom as? NSDictionary
  }
}
