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
  private var nextButtonAssetName: NSString = "next.png"
  
  private let isDisabled: Bool = false
  private lazy var button: UIButton = {
    let btn = UIButton(type: .custom)
    btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    btn.contentMode = .center
    btn.imageView?.contentMode = .scaleAspectFit
    
    btn.setImage(RNPlaylistGlobal.getFallbackResource("next.png"), for: .normal)
    return btn
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
       
    addSubview(button)
       
    // On Press Listener
    button.addTarget(self, action: #selector(self.onPress), for: .touchUpInside)
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
    
}
