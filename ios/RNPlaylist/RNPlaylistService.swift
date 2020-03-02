//
//  RNPlaylistService.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc(RNPlaylistService)
class PlaylistService: RCTEventEmitter {

  private static var playerIsReady: Bool = false
  public static var isSetup: Bool = false
  private static var throttler = Throttler(minimumDelay: 0.5)
  public static var shared: PlaylistService?
  
  private func isBridgeReady() -> Bool {
    return PlaylistService.isSetup
  }
  
  
  override init() {
    super.init()
    PlaylistService.shared = self
  }
  
  
  
  override public func constantsToExport() -> [AnyHashable: Any] {
    // "IS_PLAYING": "IS_PLAYING",
    return [:]
  }
    
  override public func supportedEvents() -> [String] {
    return [
      "onTrackPreloaded",
      "onTrackWillChange",
      "onTrackChange",
      "onTrackPlayReady",
      "onTrackPositionChange",
      "onTrackDurationChange",
      "onPlayerStateChange",
      "onPlayerReachedEnd",
      "onPlayerReady",
      "onPlayerStall",
      "onTrackLoadFailed",
      "onPlayerFailed",
      
      "remote-play",
      "remote-pause",
      "remote-stop",
      "remote-next",
      "remote-previous",
      "remote-jump-forward",
      "remote-jump-backward",
      "remote-seek",
      "remote-duck"
    ]
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  
  /**
  * Dispatchers
  */
  
  // Track
  public func dispatchTrackPreloaded(_ time: CMTime?) {
    NotificationCenter.default.post(name: .onTrackPreloaded, object: time)
    guard isBridgeReady() else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackPreloaded", body: time)
  }
  public func dispatchTrackWillChange(_ index: Int?) {
    NotificationCenter.default.post(name: .onTrackWillChange, object: index)
    guard isBridgeReady() else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackWillChange", body: index)
  }
  public func dispatchTrackChange(_ track: [String: AnyObject]?) {
    NotificationCenter.default.post(name: .onTrackChange, object: track)
    guard isBridgeReady() else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackChange", body: track)
  }
  public func dispatchTrackPlayReady() {
    NotificationCenter.default.post(name: .onTrackPlayReady, object: nil)
    guard isBridgeReady() else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackPlayReady", body: nil)
  }
  public func dispatchTrackPositionChange(_ seconds: Float?) {
    NotificationCenter.default.post(name: .onTrackPositionChange, object: seconds)
    PlaylistService.throttler.throttle {
      guard (self.isBridgeReady()) else { return }
      PlaylistService.shared?.sendEvent(withName: "onTrackPositionChange", body: seconds)
    }
  }
  public func dispatchTrackDurationChange(_ seconds: Float?) {
    NotificationCenter.default.post(name: .onTrackDurationChange, object: seconds)
    guard isBridgeReady() else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackDurationChange", body: seconds)
  }
  
  // Player
  public func dispatchPlayerStateChange(_ isPlaying: Bool) {
    if(PlaylistService.playerIsReady) {
      NotificationCenter.default.post(name: .onPlayerStateChange, object: isPlaying)
      guard isBridgeReady() else { return }
      PlaylistService.shared?.sendEvent(withName: "onPlayerStateChange", body: isPlaying)
    }
  }
  public func dispatchPlayerReachedEnd() {
    NotificationCenter.default.post(name: .onPlayerReachedEnd, object: nil)
    guard isBridgeReady() else { return }
    PlaylistService.shared?.sendEvent(withName: "onPlayerReachedEnd", body: nil)
  }
  public func dispatchPlayerReady() {
    PlaylistService.playerIsReady = true
    NotificationCenter.default.post(name: .onPlayerReady, object: nil)
    guard isBridgeReady() else { return }
    PlaylistService.shared?.sendEvent(withName: "onPlayerReady", body: nil)
  }
  public func dispatchPlayerStall() {
    NotificationCenter.default.post(name: .onPlayerStall, object: nil)
    guard isBridgeReady() else { return }
    PlaylistService.shared?.sendEvent(withName: "onPlayerStall", body: nil)
  }
  
  // Error
  public func dispatchTrackLoadFailed(_ error: NSError?) {
    NotificationCenter.default.post(name: .onTrackLoadFailed, object: error)
    guard isBridgeReady() else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackLoadFailed", body: nil)
  }
  public func dispatchPlayerFailed(_ error: NSError?) {
    PlaylistService.playerIsReady = false
    NotificationCenter.default.post(name: .onPlayerFailed, object: error)
    guard isBridgeReady() else { return }
    PlaylistService.shared?.sendEvent(withName: "onPlayerFailed", body: nil)
  }
}


extension Notification.Name {
  static let onTrackPreloaded = Notification.Name("onTrackPreloaded")
  static let onTrackWillChange = Notification.Name("onTrackWillChange")
  static let onTrackChange = Notification.Name("onTrackChange")
  static let onTrackPlayReady = Notification.Name("onTrackPlayReady")
  static let onTrackPositionChange = Notification.Name("onTrackPositionChange")
  static let onTrackDurationChange = Notification.Name("onTrackDurationChange")
  static let onPlayerStateChange = Notification.Name("onPlayerStateChange")
  static let onPlayerReachedEnd = Notification.Name("onPlayerReachedEnd")
  static let onPlayerReady = Notification.Name("onPlayerReady")
  static let onPlayerStall = Notification.Name("onPlayerStall")
  static let onTrackLoadFailed = Notification.Name("onTrackLoadFailed")
  static let onPlayerFailed = Notification.Name("onPlayerFailed")
}
