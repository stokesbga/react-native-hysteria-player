//
//  RNTrackDetails.swift
//  Playlist
//
//  Created by Alex Stokes on 2/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc(RNTimerDuration)
class RNTimerDuration : RCTViewManager {
  override func view() -> UIView! {
    return RNTimerDurationView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNTimerDurationView: UILabel {
  let isHoldingAtZero: Bool = false
    
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    
    self.textAlignment = .center
    self.textColor = .darkGray
    self.text = "0:00"
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackDurationChange),
      name: .onTrackDurationChange,
      object: nil
    )
  }
  
  // Track Position Observer
  @objc private func onTrackDurationChange(_ notification: Notification) {
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
extension RNTimerDurationView {
  
}
