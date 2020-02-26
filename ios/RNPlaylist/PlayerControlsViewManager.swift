//
//  PlayerControlsViewManager.swift
//  RnPlaylist
//
//  Created by Alex Stokes on 2/24/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
import UIKit
    
@objc(PlayerControls)
class PlayerControls: RCTViewManager, HysteriaPlayerDelegate, HysteriaPlayerDataSource {
    override func view() -> UIView! {
      let label = UILabel()
      label.text = "Swift + Quadio"
      label.textAlignment = .center
      return label
    }
}
