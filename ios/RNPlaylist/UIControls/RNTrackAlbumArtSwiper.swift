//
//  RNTrackAlbumArtSwiper.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc(RNTrackAlbumArtSwiper)
class RNTrackAlbumArtSwiper : RCTViewManager {
  override func view() -> UIView! {
    return RNTrackAlbumArtSwiperView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNTrackAlbumArtSwiperView: UIView, UIScrollViewDelegate {
	private let artMargin: CGFloat = CGFloat(64)
  private let pageControl: UIPageControl = UIPageControl()
  private let scrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.isPagingEnabled = true
    scroll.isDirectionalLockEnabled = true
    scroll.showsVerticalScrollIndicator = false
    scroll.showsHorizontalScrollIndicator = false
    scroll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return scroll
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(scrollView)
    scrollView.delegate = self
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackChange),
      name: .onTrackChange,
      object: nil
    )
    NotificationCenter.default.addObserver(self,
      selector: #selector(onQueueUpdate),
      name: .onQueueUpdate,
      object: nil
    )
  }

  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)

    if newWindow == nil {
      // UIView disappear
    } else {
      if (PlaylistService.isQueueReady) {
        let idx = SwiftPlayer.currentTrackIndex() ?? 0
        let tracks = SwiftPlayer.getPlaylist()
        self.setupAlbumArtImages(tracks)
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(idx) * self.scrollView.frame.width, y: 0), animated: false)
      }
    }
  }
  
  // Track Change Observer
  @objc private func onTrackChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let track = notification.object as? PlayerTrack else { return }
      let idx = SwiftPlayer.currentTrackIndex() ?? 0
      self.scrollView.setContentOffset(CGPoint(x: CGFloat(idx) * self.scrollView.frame.width, y: 0), animated: true)
    }
  }
  
  // On Queue State Change Observer (empty, item added)
  @objc private func onQueueUpdate(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let queue = notification.object as? PlayerQueue else { return }
      let tracks = SwiftPlayer.getPlaylist()
      self.setupAlbumArtImages(tracks)
    }
  }
  
  
  func setupAlbumArtImages(_ tracks: [PlayerTrack]) {
    scrollView.subviews.map {
      $0.removeFromSuperview()
      $0.removeConstraints($0.constraints)
    }
    scrollView.contentSize.width = scrollView.frame.width * CGFloat(max(1, tracks.count))
		let halfArtMargin = CGFloat(artMargin/2)

    for i in 0..<tracks.count {
      let imageView = UIImageView()
      imageView.af.setImage(withURL: URL( string: (tracks[i].image)!)!)
      
      let xPosition = (UIScreen.main.bounds.width * CGFloat(i)) + halfArtMargin
			imageView.frame = CGRect(x: xPosition, y: halfArtMargin, width: scrollView.frame.width - artMargin, height: scrollView.frame.height - artMargin)
      imageView.contentMode = .scaleAspectFit
      scrollView.addSubview(imageView)
      scrollView.bringSubviewToFront(imageView)
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
    let swiperWidth: CGFloat = scrollView.frame.width
    let currentPage: Int = Int(floor((scrollView.contentOffset.x-swiperWidth/2)/swiperWidth)+1)
    
    let idx = SwiftPlayer.currentTrackIndex() ?? 0
    if(idx != currentPage) {
      if(idx > currentPage) {
        SwiftPlayer.previous()
      } else {
        SwiftPlayer.next()
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
extension RNTrackAlbumArtSwiperView {
  
}
