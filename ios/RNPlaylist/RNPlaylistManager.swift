//
//  AudioPlayer.swift
//  Playlist
//
//  Created by Alex Stokes on 2/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import AlamofireImage
import AVFoundation

@objc(RNPlaylistManager)
class RNPlaylistManager: RCTEventEmitter {
    
//  var skub: Skuby!
//  var labelDuration: UILabel!
//  var labelCurrent: UILabel!
//  var labelOtherInfo: UILabel!
//  var labelTrack: UILabel!
//  var buttonPlay: UIButton!
//  var buttonShuffle: UIButton!
//  var coverAlbum: UIImageView!
//  var coverBackground: UIImageView!

  fileprivate let logs = false

  let playlist = TrackModel.localSampleData()
//
//  override init() {
//    super.init()
//  }

  deinit {
//      reset(resolve: { _ in }, reject: { _, _, _  in })
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
    
}



//MARK: - Adjust initial UI
//extension RNPlaylistManager: RCTViewManager {
//  func prepareUI() {
//    skub.setThumbImage(UIImage(named: "skubidu")!, for: UIControl.State())
//    buttonShuffle.isSelected = SwiftPlayer.isShuffle() ? true : false
//    buttonShuffle.alpha = SwiftPlayer.isShuffle() ? 1.0 : 0.33
//  }
    
//
//  override func view() -> UIView! {
//    return nil
//  }
//
//  func syncSkubyWithTime(_ time: Float) {
//    let minValue = skub.minimumValue
//    let maxValue = skub.maximumValue
//    skub.setValue(((maxValue - minValue) * time / SwiftPlayer.trackDurationTime() + minValue), animated: true)
//  }
//
//  func syncDurationTime(_ time: Float) {
//    labelDuration.text = time.toTimerString()
//  }
//
//  func syncCurrentTime(_ time: Float) {
//    labelCurrent.text = time.toTimerString()
//  }
//
//  func syncPlayButton(_ isPlaying: Bool) {
//    buttonPlay.isSelected = isPlaying ? true : false
//  }
//
//  func syncLabelsInfoWithTrack(_ track: PlayerTrack) {
//    if let name = track.name {
//      labelTrack.text = name
//    }
//
//    if let artistName = track.artist?.name {
//      if let albumName = track.album?.name {
//        labelOtherInfo.text = artistName + " — " + albumName
//        return
//      }
//      labelOtherInfo.text = artistName
//    }
//  }
//
//  func updateAlbumCoverWithURL(_ url: String) {
//        coverAlbum.af.setImage(withURL: (URL(string: url)! as URL))
//        coverBackground.af.setImage(withURL: (URL(string: url)! as URL))
//  }
//
//}


//MARK: - Actions
extension RNPlaylistManager {
  
  // private
//  func seekSkuby(_ sender: UISlider) {
//    SwiftPlayer.seekToWithSlider(sender)
//  }
  
  func beginScrubbing() {
    SwiftPlayer.pause()
  }
  
  func endScrubbing() {
    SwiftPlayer.play()
  }
  
  @objc(setupPlayer:rejecter:)
  public func setupPlayer(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
//    SwiftPlayer.isPlaying() ? SwiftPlayer.pause() : SwiftPlayer.play()
    SwiftPlayer.logs(true)
    SwiftPlayer.delegate(self)
    SwiftPlayer.newPlaylist(playlist).playAll()
  }
  
  @objc(reset:rejecter:)
  public func reset(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    
  }
  
  @objc(togglePlay:rejecter:)
  public func playPause(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
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
  
  //  @objc(seekTo:value)
  //  public func seekTo(_ val: Float) {
  //     SwiftPlayer.seekTo(val)
  //  }
  
  @objc(skipToNext:rejecter:)
  public func nextTrack(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.next()
  }
  
  @objc(skipToPrevious:rejecter:)
  public func previousTrack(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.previous()
  }
  
  @objc(toggleShuffle:rejecter:)
  public func shuffle(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    SwiftPlayer.isShuffle() ? SwiftPlayer.disableShuffle() : SwiftPlayer.enableShuffle()
//    buttonShuffle.isSelected = SwiftPlayer.isShuffle() ? true : false
//    buttonShuffle.alpha = SwiftPlayer.isShuffle() ? 1.0 : 0.33
  }
  
}

extension RNPlaylistManager: SwiftPlayerDelegate {
  
  // Update View Info with track
  func playerCurrentTrackChanged(_ track: PlayerTrack?) {
    guard let track = track else { return }
    if logs {print("••• 📻 New Track 📻")}
    if logs {print("    Song - \(track.name)")}
    if logs {print("    Artist - \(track.artist?.name)")}
    if logs {print("    Album - \(track.album?.name)")}
//    syncLabelsInfoWithTrack(track)
    if let image = track.image {
//      updateAlbumCoverWithURL(image)
    }
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
  
}


extension Float {
  /// Convert float seconds to string formatted timer
  func toTimerString() -> String {
    let minute = Int(self / 60)
    let second = Int(self.truncatingRemainder(dividingBy: 60))
    return String(format: "%01d:%02d", minute, second)
  }
}


//class Skuby: UISlider {
//  override func trackRect(forBounds bounds: CGRect) -> CGRect {
//    var result = super.trackRect(forBounds: bounds)
//    result.origin.x = -1
//    result.size.height = 3
//    result.size.width = bounds.size.width + 2
//    return result
//  }
//}


