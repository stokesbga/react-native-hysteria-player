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
  private var playIcon: String? = "play.png"
  private var pauseIcon: String? = "pause.png"
  private var disabledOpacity: CGFloat = 0.3
  private var color: UIColor = .black
  
  private lazy var button: UIButton = {
    let btn = UIButton(type: .custom)
    btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    btn.contentMode = .center
    btn.imageView?.contentMode = .scaleAspectFit
    btn.alpha = disabledOpacity
    btn.isEnabled = false
    
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
    NotificationCenter.default.addObserver(self,
      selector: #selector(onQueueStateChange),
      name: .onQueueStateChange,
      object: nil
    )
  }
  
  // isPlaying Observer
  @objc private func onPlayerStateChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let isPlaying = notification.object as? Bool else { return }
      self.button.isSelected = isPlaying ? true : false
    }
  }
  
  // On Queue State Change Observer (empty, item added)
  @objc private func onQueueStateChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let isReady = notification.object as? Bool else { return }
      self.button.isEnabled = isReady ? true : false
      self.button.alpha = isReady ? 1.0 : self.disabledOpacity;
    }
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
  
  @objc public func setDisabledOpacity(_ val: NSNumber) {
    disabledOpacity = RCTConvert.cgFloat(val ?? 0.3)
  }
  
  @objc public func setPlayIcon(_ val: NSString) {
   let img = UIImage(named: (val as? String)!, in: Bundle.main, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    button.setImage(img, for: .normal)
  }
  
  @objc public func setPauseIcon(_ val: NSString) {
    let img = UIImage(named: (val as? String)!, in: Bundle.main, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    button.setImage(img, for: .selected)
  }
  
  @objc public func setColor(_ val: NSNumber) {
    button.tintColor = RCTConvert.uiColor(val)
  }
  
}
