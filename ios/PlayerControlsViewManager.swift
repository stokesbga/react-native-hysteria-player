//
//  PlayerControlsViewManager.swift
//  RnPlaylist
//
//  Created by Alex Stokes on 2/24/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

@objc(PlayerControls)
class PlayerControls: RCTViewManager {
  override func view() -> UIView! {
    let label = UILabel()
    label.text = "Swift + Quadio"
    label.textAlignment = .center
    return label
  }
}
