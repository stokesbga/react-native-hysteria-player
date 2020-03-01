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
  private var prevButtonAssetName: NSString = "prev.png"
  
  private let isDisabled: Bool = false
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
