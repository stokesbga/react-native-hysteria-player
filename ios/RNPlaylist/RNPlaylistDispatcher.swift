//
//  RNPlaylistDispatcher.swift
//  Playlist
//
//  Created by Alex Stokes on 2/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import AlamofireImage
import AVFoundation

@objc(RNPlaylistDispatcher)
class RNPlaylistDispatcher : NSObject {

  var skub: Skuby!
  var labelDuration: UILabel!
  var labelCurrent: UILabel!
  var labelOtherInfo: UILabel!
  var labelTrack: UILabel!
  var buttonPlay: UIButton!
  var buttonShuffle: UIButton!
  var coverAlbum: UIImageView!
  var coverBackground: UIImageView!

  fileprivate let logs = true

  let playlist = TrackModel.localSampleData()

  override init() {
    super.init()
    
    // SwiftPlayer.newPlaylist(playlist).playAll()
    
  }

//  deinit {
//      reset(resolve: { _ in }, reject: { _, _, _  in })
//  }
    
  @objc static func requiresMainQueueSetup() -> Bool {
      return false
  }
}


//MARK: - Adjust initial UI
extension RNPlaylistDispatcher {
  func prepareUI() {
    skub.setThumbImage(UIImage(named: "skubidu")!, for: UIControl.State())
    buttonShuffle.isSelected = SwiftPlayer.isShuffle() ? true : false
    buttonShuffle.alpha = SwiftPlayer.isShuffle() ? 1.0 : 0.33
  }

  func syncSkubyWithTime(_ time: Float) {
    let minValue = skub.minimumValue
    let maxValue = skub.maximumValue
    skub.setValue(((maxValue - minValue) * time / SwiftPlayer.trackDurationTime() + minValue), animated: true)
  }

  func syncDurationTime(_ time: Float) {
    labelDuration.text = time.toTimerString()
  }

  func syncCurrentTime(_ time: Float) {
    labelCurrent.text = time.toTimerString()
  }

  func syncPlayButton(_ isPlaying: Bool) {
    buttonPlay.isSelected = isPlaying ? true : false
  }

  func syncLabelsInfoWithTrack(_ track: PlayerTrack) {
    if let name = track.name {
      labelTrack.text = name
    }

    if let artistName = track.artist?.name {
      if let albumName = track.album?.name {
        labelOtherInfo.text = artistName + " — " + albumName
        return
      }
      labelOtherInfo.text = artistName
    }
  }

  func updateAlbumCoverWithURL(_ url: String) {
        coverAlbum.af.setImage(withURL: (URL(string: url)! as URL))
        coverBackground.af.setImage(withURL: (URL(string: url)! as URL))
  }

}


//MARK: - Actions
extension RNPlaylistDispatcher {

  // private
  func seekSkuby(_ sender: UISlider) {
    SwiftPlayer.seekToWithSlider(sender)
  }

  func beginScrubbing() {
    SwiftPlayer.pause()
  }

  func endScrubbing() {
    SwiftPlayer.play()
  }

  @objc(setupPlayer:rejecter:)
  public func setupPlayer(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
//    SwiftPlayer.isPlaying() ? SwiftPlayer.pause() : SwiftPlayer.play()
    SwiftPlayer.newPlaylist(playlist).playAll()
    resolve(true)
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


class Skuby: UISlider {
  override func trackRect(forBounds bounds: CGRect) -> CGRect {
    var result = super.trackRect(forBounds: bounds)
    result.origin.x = -1
    result.size.height = 3
    result.size.width = bounds.size.width + 2
    return result
  }
}


