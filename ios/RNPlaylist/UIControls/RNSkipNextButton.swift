//
//  RNSkipNextButton.swift
//  Playlist
//
//  Created by Alex Stokes on 2/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc(RNSkipNextButton)
class RNSkipNextButton : RCTViewManager {
  override func view() -> UIView! {
    return RNSkipNextButtonView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNSkipNextButtonView: UIView {
  // React Props
  private var icon: String? = ""
  private var disabledOpacity: CGFloat = 0.3
  private var color: UIColor = .black
  
  private lazy var button: UIButton = {
    let btn = UIButton(type: .custom)
    btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    btn.contentMode = .center
    btn.imageView?.contentMode = .scaleAspectFit
    btn.alpha = disabledOpacity
    btn.isEnabled = false
    
    btn.setImage(RNPlaylistGlobal.getFallbackResource("next.png"), for: .normal)
    return btn
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
       
    addSubview(button)
       
    // On Press Listener
    button.addTarget(self, action: #selector(self.onPress), for: .touchUpInside)
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackChange),
      name: .onTrackChange,
      object: nil
    )
    NotificationCenter.default.addObserver(self,
      selector: #selector(onQueueStateChange),
      name: .onQueueStateChange,
      object: nil
    )
  }
  
  // Track Change Observer
  @objc private func onTrackChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let track = notification.object as? [String: AnyObject] else { return }
      let idx = SwiftPlayer.currentTrackIndex()
      let total = SwiftPlayer.totalTracks()
      if (idx == (total-1) || total == 0) {
        self.button.isEnabled = false
        self.button.alpha = self.disabledOpacity;
      } else {
        self.button.isEnabled = true
        self.button.alpha = 1.0;
      }
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

  // On Press
  @objc private func onPress(sender: UIButton!) {
    print("On Press Next")
    SwiftPlayer.next()
  }

  // Required
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


/**************
*  React Props  *
**************/
extension RNSkipNextButtonView {
  @objc public func setDisabledOpacity(_ val: NSNumber) {
    disabledOpacity = RCTConvert.cgFloat(val ?? 0.3)
  }
  
  @objc public func setIcon(_ val: NSString) {
    let img = UIImage(named: (val as? String)!, in: Bundle.main, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    button.setImage(img, for: .normal)
  }
  
  @objc public func setColor(_ val: NSNumber) {
    button.tintColor = RCTConvert.uiColor(val)
  }
}
