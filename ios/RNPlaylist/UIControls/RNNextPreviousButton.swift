//
//  RNNextPreviousButton.swift
//  Playlist
//
//  Created by Alex Stokes on 2/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc(RNNextPreviousButton)
class RNNextPreviousButton : RCTViewManager {
  override func view() -> UIView! {
    return RNNextPreviousButtonView(type: .custom)
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNNextPreviousButtonView: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    self.setTitle("NEXT", for: .normal)
    self.addTarget(self, action: #selector(self.onPress), for: .touchUpInside)
    // self.frame = CGRect(x: 100, y: 400, width: 100, height: 50)
  }

  @objc(onPress:)
  func onPress(sender: UIButton!) {
    print("On Press Next")
    SwiftPlayer.next()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
//  @objc var playButtonImage: String = "play" {
//    didSet {
//      self.setImage(UIImage(named: playButtonImage), for: .normal)
//    }
//  }
//
//  @objc var pauseButtonImage: String = "pause" {
//    didSet {
//      self.setImage(UIImage(named: pauseButtonImage), for: .selected)
//    }
//  }
}
