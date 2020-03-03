//
//  RNTrackArtist.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import MarqueeLabel


@objc(RNTrackArtist)
class RNTrackArtist : RCTViewManager {
  override func view() -> UIView! {
    return RNTrackArtistView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNTrackArtistView: UIView {
	private var fontFamily: String = "System"
	private var fontSize: CGFloat = 18.0
	private var color: UIColor = .black
	private var textAlign: NSTextAlignment = .left
	private lazy var marqueeLabel: MarqueeLabel = {
    let label = MarqueeLabel(frame: CGRect(), duration: 8.0, fadeLength: 10.0)
    label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    label.contentMode = .center
		label.textAlignment = textAlign
		label.textColor = color
		label.text = RNPlaylist.emptyArtistTitle
    return label
  }()
	
  override init(frame: CGRect) {
    super.init(frame: frame)
		
		marqueeLabel.frame = frame
		addSubview(marqueeLabel)
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackChange),
      name: .onTrackChange,
      object: nil
    )
    NotificationCenter.default.addObserver(self,
      selector: #selector(onQueueStateChange),
      name: .onQueueStateChange,
      object: nil
    )
  }

  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)

    if newWindow == nil {
        // UIView disappear
    } else {
      if (PlaylistService.isQueueReady) {
        let track = SwiftPlayer.trackAtIndex(SwiftPlayer.currentTrackIndex() as? Int ?? 0)
        marqueeLabel.text = track.artist?.name ?? RNPlaylist.emptyArtistTitle
      } else {
        marqueeLabel.text = RNPlaylist.emptyArtistTitle
      }
    }
  }
  
  // Track Change Observer
  @objc private func onTrackChange(_ notification: Notification) {
		DispatchQueue.main.async {
			guard let track = notification.object as? [String: AnyObject] else { return }
			self.marqueeLabel.text = track["artist"] as? String ?? "None"
		}
  }
	
  // On Queue State Change Observer (empty, item added)
  @objc private func onQueueStateChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let isReady = notification.object as? Bool else { return }
      if(!isReady) {
				self.marqueeLabel.text = RNPlaylist.emptyArtistTitle
      }
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
extension RNTrackArtistView {
  
  @objc public func setFontFamily(_ val: NSString) {
		fontFamily = val as? String ?? "System"
		let font = UIFont(name: fontFamily, size: fontSize)
		marqueeLabel.font = font
  }
	
	@objc public func setFontSize(_ val: NSNumber) {
		fontSize = RCTConvert.cgFloat(val) ?? 18
		let font = UIFont(name: fontFamily, size: fontSize)
		marqueeLabel.font = font
  }
	
	@objc public func setColor(_ val: NSNumber) {
		color = RCTConvert.uiColor(val) ?? .black
		marqueeLabel.textColor = color
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
		marqueeLabel.textAlignment = textAlign
  }
	
}
