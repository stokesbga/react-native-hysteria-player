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
    return RNPlayPauseButtonView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNPlayPauseButtonView: UIView {
  // React Props
  private var playButtonAssetName: NSString = "play.png"
  private var pauseButtonAssetName: NSString = "pause.png"
  
  private lazy var button: UIButton = {
    let btn = UIButton(type: .custom)
    btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    btn.contentMode = .center
    btn.imageView?.contentMode = .scaleAspectFit
    
    btn.setImage(RNPlaylistGlobal.getFallbackResource("play.png"), for: .normal)
    btn.setImage(RNPlaylistGlobal.getFallbackResource("pause.png"), for: .selected)
    return btn
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(button)
    
    // On Press Listener
    button.addTarget(self, action: #selector(self.onPress), for: .touchUpInside)
    
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
    print("PLAY IS PLAYING", isPlaying)
//    self.button.isSelected = isPlaying ? true : false
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
  
  @objc public func setPlayButtonAssetName(_ val: NSString) {
    guard let assetStr = val as? String else { return }
    let img = UIImage(named: assetStr, in: Bundle.main, compatibleWith: nil) ?? RNPlaylistGlobal.getFallbackResource("play.png")
    button.setImage(img, for: .normal)
    playButtonAssetName = val ?? "play.png"
  }
  
  @objc public func setPauseButtonAssetName(_ val: NSString) {
    guard let assetStr = val as? String else { return }
    let img = UIImage(named: assetStr, in: Bundle.main, compatibleWith: nil) ?? RNPlaylistGlobal.getFallbackResource("pause.png")
    button.setImage(img, for: .selected)
    pauseButtonAssetName = val ?? "pause.png"
  }
}
