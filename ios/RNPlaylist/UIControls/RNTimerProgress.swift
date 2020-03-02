//
//  RNTimerProgress.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc(RNTimerProgress)
class RNTimerProgress : RCTViewManager {
  override func view() -> UIView! {
    return RNTimerProgressView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNTimerProgressView: UILabel {
  // React Props
  private var fontFamily: String = "System"
  private var fontSize: CGFloat = 18.0
  private var color: UIColor = .black
  private var textAlign: NSTextAlignment = .left
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    
    self.textAlignment = textAlign
    self.textColor = color
    self.text = "0:00"
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackPositionChange),
      name: .onTrackPositionChange,
      object: nil
    )
  }
  
  // Track Position Observer
  @objc private func onTrackPositionChange(_ notification: Notification) {
    DispatchQueue.main.async { [unowned self] in
      guard let seconds = notification.object as? Float else { return }
      self.text = seconds.toTimerString()
    }
  }

    
  // Required
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


/**************
*  React Props  *
**************/
extension RNTimerProgressView {
  
  @objc public func setFontFamily(_ val: NSString) {
    fontFamily = val as? String ?? "System"
    let font = UIFont(name: fontFamily, size: fontSize)
    self.font = font
  }
  
  @objc public func setFontSize(_ val: NSNumber) {
    fontSize = RCTConvert.cgFloat(val) ?? 18
    let font = UIFont(name: fontFamily, size: fontSize)
    self.font = font
  }
  
  @objc public func setColor(_ val: NSNumber) {
    color = RCTConvert.uiColor(val) ?? .black
    self.textColor = color
  }
  
  @objc public func setTextAlign(_ val: NSNumber) {
    textAlign = {
      switch(val as? Int ?? 0) {
      case 0:
        return .left
      case 1:
        return .center
      case 2:
        return .right
      default:
        return .left
      }
    }()
    self.textAlignment = textAlign
  }
  
}
