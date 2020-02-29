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
    return RNSkipPrevButtonView(type: .custom)
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNSkipPrevButtonView: UIButton {
  let isDisabled: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    self.setImage(UIImage(named: "prev.png", in: RNPlaylistGlobal.getResourceBundle(), compatibleWith: nil), for: .normal)
    self.addTarget(self, action: #selector(self.onPress), for: .touchUpInside)
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
  
}
