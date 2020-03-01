//
//  RNSkipPrevButton.swift
//  Playlist
//
//  Created by Alex Stokes on 2/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc(RNSkipPrevButton)
class RNSkipPrevButton : RCTViewManager {
  override func view() -> UIView! {
    return RNSkipPrevButtonView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNSkipPrevButtonView: UIView {
  // React Props
  private var icon: String?
  private var disabledOpacity: CGFloat = 0.3
  
  private lazy var button: UIButton = {
    let btn = UIButton(type: .custom)
    btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    btn.contentMode = .center
    btn.imageView?.contentMode = .scaleAspectFit
    
    btn.setImage(RNPlaylistGlobal.getFallbackResource("prev.png"), for: .normal)
    return btn
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
          
    addSubview(button)
    
    button.addTarget(self, action: #selector(self.onPress), for: .touchUpInside)
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackChange),
      name: .onTrackChange,
      object: nil
    )
  }

  // Track Change Observer
  @objc private func onTrackChange(_ notification: Notification) {
    guard let track = notification.object as? [String: AnyObject] else { return }
    let idx = SwiftPlayer.currentTrackIndex()
    let total = SwiftPlayer.totalTracks()
    if (idx == 0) {
      button.isEnabled = false
      button.alpha = disabledOpacity;
    } else {
      button.isEnabled = true
      button.alpha = 1.0;
    }
  }
  
  // On Press
  @objc private func onPress(sender: UIButton!) {
    print("On Press Prev")
    SwiftPlayer.previous()
  }

  // Required
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


/**************
*  React Props  *
**************/
extension RNSkipPrevButtonView {
  
  @objc public func setDisabledOpacity(_ val: NSNumber) {
    disabledOpacity = RCTConvert.cgFloat(val ?? 0.3)
  }
  
  @objc public func setIcon(_ val: NSString) {
    button.setImage(UIImage(named: (val as? String)!, in: Bundle.main, compatibleWith: nil), for: .normal)
  }
  
}
