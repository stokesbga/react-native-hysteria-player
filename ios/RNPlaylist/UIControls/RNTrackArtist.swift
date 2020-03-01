//
//  RNTrackArtist.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import MarqueeLabel


@objc(RNTrackArtist)
class RNTrackArtist : RCTViewManager {
  override func view() -> UIView! {
    return RNTrackArtistView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNTrackArtistView: UIView {
	private lazy var marqueeLabel: MarqueeLabel = {
    let label = MarqueeLabel(frame: CGRect(), duration: 8.0, fadeLength: 10.0)
    label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    label.contentMode = .center
		label.textAlignment = .center
		label.textColor = .black
		label.text = "None"
    return label
  }()
	
  override init(frame: CGRect) {
    super.init(frame: frame)
		
		marqueeLabel.frame = frame
		addSubview(marqueeLabel)
    
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
		marqueeLabel.text = track["artist"] as? String ?? "None"
  }

    
  // Required
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


/**************
*  React Props  *
**************/
extension RNTrackArtistView {
  
}
