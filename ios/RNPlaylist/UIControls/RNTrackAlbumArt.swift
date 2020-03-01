//
//  RNTrackAlbumArt.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import MediaPlayer

@objc(RNTrackAlbumArt)
class RNTrackAlbumArt : RCTViewManager {
  override func view() -> UIView! {
    return RNTrackAlbumArtView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNTrackAlbumArtView: UIView {
  private lazy var imageView: UIImageView = {
    let image = RNPlaylistGlobal.getFallbackResource("placeholder.png")
    let imgView = UIImageView(image: image)
    imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    imgView.contentMode = .scaleAspectFit
    return imgView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
		
    addSubview(imageView)
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackChange),
      name: .onTrackChange,
      object: nil
    )
  }
  
  // Track Change Observer
  @objc private func onTrackChange(_ notification: Notification) {
    guard let track = notification.object as? [String: AnyObject] else { return }
    self.imageView.image = track["albumArtUIImage"] as? UIImage
  }

    
  // Required
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


/**************
*  React Props  *
**************/
extension RNTrackAlbumArtView {
  
}
