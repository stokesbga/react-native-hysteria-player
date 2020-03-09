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
  public let expires: Date
  public let custom: NSDictionary?
  public var AVMediaPlayerProperties: [String: AnyObject]?
    
  public var dictionary: [String: Any] {
    let formatter = ISO8601DateFormatter()
    return [
      "url": url as? Any,
      "name": name as? Any,
      "image": image as? Any,
      "album": album?.name as? Any,
      "artist": artist?.name as? Any,
      "expires": formatter.string(from: expires) as? Any,
      "AVMediaPlayerProperties": AVMediaPlayerProperties as? Any,
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
  
  public init(url: String, name: String? = nil, image: String? = nil, album: String? = nil, artist: String? = nil, expires: Date, custom: NSDictionary?) {
    self.url = url
    self.name = name
    self.image = image
    self.album = Album(name: album)
    self.artist = Artist(name: artist)
    self.expires = expires
    self.custom = custom as? NSDictionary
  }
}
