//
//  RNPlaybarSlider.swift
//  Playlist
//
//  Created by Alex Stokes on 2/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc(RNPlaybarSlider)
class RNPlaybarSlider : RCTViewManager {
  override func view() -> UIView! {
     return RNPlaybarSliderView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class PlaybarSlider: UISlider {
  override func trackRect(forBounds bounds: CGRect) -> CGRect {
    var result = super.trackRect(forBounds: bounds)
    result.origin.x = -1
    result.size.height = 3
    result.size.width = bounds.size.width + 2
    return result
  }
}

class RNPlaybarSliderView: PlaybarSlider {

  @objc var theme: NSDictionary = [
    "trackPlayedColor": UIColor.blue,
    "trackRemainingColor": UIColor.green
    ] {
      didSet {
        self.tintColor = RCTConvert.uiColor(theme["trackPlayedColor"])
        self.maximumTrackTintColor = RCTConvert.uiColor(theme["trackRemainingColor"])
      }
    }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    self.minimumValue = 0
    self.maximumValue = 100
    self.isContinuous = true
    // self.addTarget(self, action // blah blah)

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
