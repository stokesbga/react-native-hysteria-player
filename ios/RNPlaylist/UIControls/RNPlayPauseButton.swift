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
  private var playButtonImage: UIImage = UIImage()
  private var pauseButtonImage: UIImage = UIImage()
  
  private lazy var playButtonImageFallback: UIImage = {
    let img = UIImage(named: "play.png", in: RNPlaylistGlobal.getResourceBundle(), compatibleWith: nil)
    self.setImage(img, for: .normal)
    return img ?? UIImage()
  }()
  
  private lazy var pauseButtonImageFallback: UIImage = {
    let img = UIImage(named: "pause.png", in: RNPlaylistGlobal.getResourceBundle(), compatibleWith: nil)
    self.setImage(img, for: .selected)
    return img ?? UIImage()
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    
    self.playButtonImage = playButtonImageFallback
    self.pauseButtonImage = pauseButtonImageFallback
    
    // On Press Listener
    self.addTarget(self, action: #selector(self.onPress), for: .touchUpInside)
    
    // Notification Subscriber
   NotificationCenter.default.addObserver(self,
     selector: #selector(onPlayerStateChange),
     name: .onPlayerStateChange,
     object: nil
   )
  }
  
  // isPlaying Observer
  @objc private func onPlayerStateChange(_ notification: Notification) {
    guard let isPlaying = notification.object as? Bool else { return }
    self.isSelected = isPlaying ? true : false
  }

  // On Press Handler
  @objc(onPress:)
  func onPress(sender: UIButton!) {
    SwiftPlayer.playToggle()
  }
  
  
  // Required
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


/**************
*  React Props  *
**************/
extension RNPlayPauseButtonView {
  
  @objc public func setPlayButtonImage(_ val: NSString) {
    guard let assetStr = val as? String else { return }
    let img = UIImage(named: assetStr, in: Bundle.main, compatibleWith: nil)
    self.setImage(img, for: .normal)
    self.playButtonImage = img ?? self.playButtonImageFallback
  }
  
  @objc public func setPauseButtonImage(_ val: NSString) {
    guard let assetStr = val as? String else { return }
    let img = UIImage(named: assetStr, in: Bundle.main, compatibleWith: nil)
    self.setImage(img, for: .selected)
    self.pauseButtonImage = img ?? self.pauseButtonImageFallback
  }
}
