//
//  Float+toTimerString.swift
//  Playlist
//
//  Created by Alex Stokes on 2/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

extension Float {
  /// Convert float seconds to string formatted timer
  func toTimerString() -> String {
    let minute = Int(self / 60)
    let second = Int(self.truncatingRemainder(dividingBy: 60))
    return String(format: "%01d:%02d", minute, second)
  }
}
