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
    return RNSkipNextButtonView(type: .custom)
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNSkipNextButtonView: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    self.setImage(UIImage(named: "next.png", in: RNPlaylistGlobal.getResourceBundle(), compatibleWith: nil), for: .normal)
    self.addTarget(self, action: #selector(self.onPress), for: .touchUpInside)
  }

  @objc(onPress:)
  func onPress(sender: UIButton!) {
    print("On Press Next")
    SwiftPlayer.next()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
