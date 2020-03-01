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

  @objc(setup:rejecter:)
  public func setup(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    PlaylistService.isSetup = true
    resolve(NSNull())
  }

  @objc(reset:rejecter:)
  public func reset(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.pause()
    SwiftPlayer.setPlaylist([PlayerTrack]())
  }
    
  @objc(addTracks:)
  public func addTracks(_ tracks: [[String: Any]]) {
    SwiftPlayer.pause()
    
    var queue = [PlayerTrack]()
    for track in tracks {
      let trackUrl = track["url"] as? String ?? ""
      guard let trackTitle = track["title"] as? String else { return }
      guard let trackArtwork = track["artwork"] as? String else { return }
      guard let trackAlbum = track["album"] as? String else { return }
      guard let trackArtist = track["artist"] as? String else { return }
      guard let trackCustom = track["custom"] as? NSDictionary else { return }
        
      let playerTrack = PlayerTrack(url: trackUrl, name: trackTitle, image: trackArtwork, album: trackAlbum, artist: trackArtist, custom: trackCustom)
      queue.append(playerTrack)
    }
    
    SwiftPlayer.setPlaylist(queue).playAll()
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

