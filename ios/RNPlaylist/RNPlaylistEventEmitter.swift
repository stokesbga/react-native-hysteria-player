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
class RNPlaylistEventEmitter: RCTEventEmitter {
  
  fileprivate let logs = true
  
  override init() {
    super.init()
    
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
}



