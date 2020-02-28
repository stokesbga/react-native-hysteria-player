//
//  RNPlayPauseButton.swift
//  Playlist
//
//  Created by Alex Stokes on 2/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc(RNPlayPauseButton)
class RNPlayPauseButton : RCTViewManager {
  override func view() -> UIView! {
    return RNPlayPauseButtonView(type: .custom)
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNPlayPauseButtonView: UIButton {
    
  var isPlaying: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    self.setTitle("▶️", for: .normal)
    self.setTitle("⏸", for: .selected)
    self.addTarget(self, action: #selector(self.onPress), for: .touchUpInside)
    // self.frame = CGRect(x: 100, y: 400, width: 100, height: 50)
  }

  @objc(onPress:)
  func onPress(sender: UIButton!) {
    print("On Press Play")
    isPlaying = !isPlaying
    if(isPlaying) {
      SwiftPlayer.pause()
    } else {
      SwiftPlayer.play()
    }
    self.isSelected = isPlaying ? true : false
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc var playButtonImage: String = "play" {
    didSet {
      self.setImage(UIImage(named: playButtonImage), for: .normal)
    }
  }
  
  @objc var pauseButtonImage: String = "pause" {
    didSet {
      self.setImage(UIImage(named: pauseButtonImage), for: .selected)
    }
  }
}
