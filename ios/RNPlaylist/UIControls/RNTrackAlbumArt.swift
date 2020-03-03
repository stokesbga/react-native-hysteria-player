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
    // @todo - create imagefallback prop RNPlaylistGlobal.getFallbackResource("placeholder.png")
    let image = UIImage()
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
        guard let img = track.image as? String else {
          imageView.image = UIImage()
          return
        }
        imageView.af.setImage(withURL: URL(string: img)!)
        return
      }
      imageView.image = UIImage()
    }
  }
  
  // Track Change Observer
  @objc private func onTrackChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let track = notification.object as? [String: AnyObject] else { return }
      self.imageView.image = track["albumArtUIImage"] as? UIImage
    }
  }
  
  // On Queue State Change Observer (empty, item added)
  @objc private func onQueueStateChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let isReady = notification.object as? Bool else { return }
      if(!isReady) {
        self.imageView.image = UIImage()
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
extension RNTrackAlbumArtView {
  
}
