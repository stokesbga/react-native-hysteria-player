//
//  RNTimerProgress.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc(RNTimerProgress)
class RNTimerProgress : RCTViewManager {
  override func view() -> UIView! {
    return RNTimerProgressView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNTimerProgressView: UILabel {
  let isHoldingAtZero: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    self.textColor = .darkGray
    self.text = "0:00"
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackPositionChange),
      name: .onTrackPositionChange,
      object: nil
    )
  }
  
  // Track Position Observer
  @objc private func onTrackPositionChange(_ notification: Notification) {
    guard let seconds = notification.object as? Float else { return }
    self.text = seconds.toTimerString()
  }

    
  // Required
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


/**************
*  React Props  *
**************/
extension RNTimerProgressView {
  
}
