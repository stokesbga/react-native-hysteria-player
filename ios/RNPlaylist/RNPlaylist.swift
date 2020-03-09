//
//  RNPlaylist.swift
//  Playlist
//
//  Created by Alex Stokes on 2/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import AlamofireImage
import AVFoundation

@objc(RNPlaylist)
class RNPlaylist : NSObject {
  
  // Config static vars
  public static var emptyTrackTitle = "None"
  public static var emptyArtistTitle = "None"
  

  override init() {
    super.init()
  }

  deinit {}
    
  @objc static func requiresMainQueueSetup() -> Bool {
    return false
  }
}


//MARK: - Adjust initial UI
extension RNPlaylist {

  @objc(setup:)
  public func setup(_ config: [String: Any]) {
    let enableEvents = config["enableEvents"] as? [String] ?? []
    let enableCache = config["enableCache"] as? Bool ?? false
    let enableLogs = config["enableLogs"] as? Bool ?? false
    let enableTrackUrlCallbacks = config["enableTrackUrlCallbacks"] as? Bool ?? false
    
    RNPlaylist.emptyTrackTitle = config["emptyTrackTitle"] as? String ?? "None"
    RNPlaylist.emptyArtistTitle = config["emptyArtistTitle"] as? String ?? "None"
    
    PlaylistService.subscribedEvents = enableEvents
    
    SwiftPlayer.setup()
    
    if(enableTrackUrlCallbacks) {
      SwiftPlayer.enableTrackUrlCallbacks()
    }
    
    if(enableCache) {
      SwiftPlayer.enableCache(true)
    }
    
    if(enableLogs) {
      SwiftPlayer.logs(true)
    }
  }

  @objc(teardown:rejecter:)
  public func teardown(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.teardown()
  }
    
  @objc(addTracks:)
  public func addTracks(_ tracks: [[String: Any]]) {
    if (SwiftPlayer.totalTracks() > 0) {
      SwiftPlayer.play()
    }
    
    var queue = [PlayerTrack]()
    for track in tracks {
      let trackUrl = track["url"] as? String ?? ""
      guard let trackTitle = track["title"] as? String else { return }
      guard let trackArtwork = track["artwork"] as? String else { return }
      guard let trackAlbum = track["album"] as? String else { return }
      guard let trackArtist = track["artist"] as? String else { return }
      let trackExpirationTime = RCTConvert.nsDate(track["expires"]) ?? Date.distantFuture
      let trackCustom = track["custom"] as? NSDictionary ?? [:]
        
      let playerTrack = PlayerTrack(url: trackUrl, name: trackTitle, image: trackArtwork, album: trackAlbum, artist: trackArtist, expires: trackExpirationTime, custom: trackCustom)
      queue.append(playerTrack)
    }
    
    SwiftPlayer.setPlaylist(queue).playAll()
  }

  @objc(setupTrackURL:index:)
  public func setupTrackURL(_ url: String, index: NSNumber) {
    SwiftPlayer.setupTrack(url, index: (index as? Int)!)
  }
  
  @objc(getCurrentTrack:rejecter:)
  public func getCurrentTrack(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    let track = SwiftPlayer.currentPlayerTrack()
    resolve(track)
  }
  
  @objc(togglePlay:rejecter:)
  public func togglePlay(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.isPlaying() ? SwiftPlayer.pause() : SwiftPlayer.play()
  }

  @objc(play:rejecter:)
  public func play(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.play()
  }

  @objc(pause:rejecter:)
  public func pause(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.pause()
  }
  
  @objc(seekTo:)
  public func seekTo(_ seconds: NSNumber) {
    SwiftPlayer.seekToS(RCTConvert.double(seconds))
  }

  @objc(skipToNext:rejecter:)
  public func skipToNext(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.next()
  }

  @objc(skipToPrevious:rejecter:)
  public func skipToPrevious(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.previous()
  }

  @objc(toggleShuffle:rejecter:)
  public func toggleShuffle(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.isShuffle() ? SwiftPlayer.disableShuffle() : SwiftPlayer.enableShuffle()
  }
}

