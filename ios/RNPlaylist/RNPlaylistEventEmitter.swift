//
//  RNPlaylistEventEmitter.swift
//  Playlist
//
//  Created by Alex Stokes on 2/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import AlamofireImage
import AVFoundation

@objc(RNPlaylistEventEmitter)
class RNPlaylistEventEmitter: RCTEventEmitter, SwiftPlayerDelegate, SwiftPlayerQueueDelegate {

  fileprivate let logs = true
  
  override init() {
    super.init()
    
    SwiftPlayer.logs(true)
//    SwiftPlayer.delegate(self)
//    SwiftPlayer.queueDelegate(self)
    
  }

  deinit {
    // reset(resolve: { _ in }, reject: { _, _, _  in })
  }
    
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  override public func constantsToExport() -> [AnyHashable: Any] {
    return [
      "STATE_NONE": "STATE_NONE",
      "STATE_READY": "STATE_READY",
      "STATE_PLAYING": "STATE_PLAYING",
      "STATE_PAUSED": "STATE_PAUSED",
      "STATE_STOPPED": "STATE_STOPPED",
      "STATE_BUFFERING": "STATE_BUFFERING"
    ]
  }
    
  override public func supportedEvents() -> [String] {
    return [
      "playback-state",
      "playback-error",
      "playback-track-changed"
    ]
  }
  
  
  // Player Delegate Events
 // Update View Info with track
  func playerCurrentTrackChanged(_ track: PlayerTrack?) {
    guard let track = track else { return }
    if logs {print("••• 📻 New Track 📻")}
    if logs {print("    Song - \(track.name)")}
    if logs {print("    Artist - \(track.artist?.name)")}
    if logs {print("    Album - \(track.album?.name)")}
//    syncLabelsInfoWithTrack(track)
//    if let image = track.image {
//      updateAlbumCoverWithURL(image)
//    }
  }
  
  // Update button play
  func playerRateChanged(_ isPlaying: Bool) {
    let status = isPlaying ? "⏸" : "▶️"
    if logs {print("••• \(status) Status Button \(status)")}
//    syncPlayButton(isPlaying)
  }
  
  // Update duration time
  func playerDurationTime(_ time: Float) {
    if logs {print("••• ⌛️ \(time.toTimerString())")}
//    syncDurationTime(time)
  }
  
  // Update current time
  func playerCurrentTimeChanged(_ time: Float) {
    if logs {print("••• ⏱ \(time.toTimerString())")}
//    syncSkubyWithTime(time)
//    syncCurrentTime(time)
  }
  
  // Queue Delegate Events
  func queueUpdated() {
      print("Queue delegate updated")
    }
    
}


//extension RNPlaylistEventEmitter: SwiftPlayerDelegate {
//
//
//}
//
//extension RNPlaylistEventEmitter: SwiftPlayerQueueDelegate {
//  func queueUpdated() {
//     print("Queue delegate updated")
//   }
//}


