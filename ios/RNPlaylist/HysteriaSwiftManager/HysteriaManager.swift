//
//  HysteriaManager.swift
//  Pods
//
//  Created by iTSangar on 1/15/16.
//
//

import UIKit
import Foundation
import MediaPlayer

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


// MARK: - HysteriaManager
class HysteriaManager: NSObject {

  static let sharedInstance = HysteriaManager()
  var hysteriaPlayer = HysteriaPlayer.sharedInstance()

  var logs = false
  var queue = PlayerQueue()
  
  let playlistService = PlaylistService.shared

  fileprivate let commandCenter = MPRemoteCommandCenter.shared()
  fileprivate var isClicked = false
  fileprivate var lastIndexClicked = -1
  fileprivate var lastIndexShuffle = -1

  public var enableTrackUrlCallbacks: Bool = false

  // Init
  func initHysteriaPlayer() {
    hysteriaPlayer?.delegate = self;
    hysteriaPlayer?.enableMemoryCached(false)
    enableCommandCenter()
  }
  
  // Teardown
  func teardownHysteriaPlayer() {
    hysteriaPlayer?.deprecatePlayer();
  }
}


// MARK: - HysteriaManager - UI
extension HysteriaManager {
  fileprivate func currentTime() {
    hysteriaPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 100, timescale: 1000), queue: nil, using: {
      time in
      let totalSeconds = CMTimeGetSeconds(time)
      self.playlistService?.dispatchTrackPositionChange(Float(totalSeconds))
    })
  }

  fileprivate func updateCurrentItem() -> PlayerTrack? {
    let trackMeta = infoCenterWithTrack(currentPlayerTrack())
    let duration = hysteriaPlayer?.getPlayingItemDurationTime()
    if duration > 0 {
      self.playlistService?.dispatchTrackDurationChange(Float(duration!))
    }
        
    return trackMeta
  }

}


// MARK: - HysteriaManager - MPNowPlayingInfoCenter
extension HysteriaManager {
  
  func setMemoryCached(_ enable: Bool) {
    hysteriaPlayer?.enableMemoryCached(enable)
  }
  
  func getCurrentPosition() -> Float {
    return hysteriaPlayer?.getPlayingItemCurrentTime() ?? 0.0
  }

  func updateImageInfoCenter(_ image: UIImage) {
    if var dictionary = MPNowPlayingInfoCenter.default().nowPlayingInfo {
      dictionary[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
    }
  }

  fileprivate func infoCenterWithTrack(_ track: PlayerTrack?) -> PlayerTrack? {
    guard var track = track else { return nil }

    var dictionary: [String : AnyObject] = [
      MPMediaItemPropertyAlbumTitle: "" as AnyObject,
      MPMediaItemPropertyArtist: "" as AnyObject,
      MPMediaItemPropertyPlaybackDuration: TimeInterval(hysteriaPlayer!.getPlayingItemDurationTime()) as AnyObject,
      MPMediaItemPropertyTitle: "" as AnyObject]

    if let albumName = track.album?.name {
      dictionary[MPMediaItemPropertyAlbumTitle] = albumName as AnyObject
    }
    if let artistName = track.artist?.name {
      dictionary[MPMediaItemPropertyArtist] = artistName as AnyObject
    }
    if let name = track.name {
      dictionary[MPMediaItemPropertyTitle] = name as AnyObject
    }
    if let image = track.image,
      let loaded = imageFromString(image) {
        dictionary[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: loaded)
        dictionary["albumArtUIImage"] = loaded
        dictionary["albumArtURL"] = track.image as AnyObject?
    }
  
    MPNowPlayingInfoCenter.default().nowPlayingInfo = dictionary
    track.AVMediaPlayerProperties = dictionary
    return track
  }

  fileprivate func imageFromString(_ imagePath: String) -> UIImage? {
    let detectorr = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detectorr.matches(in: imagePath, options: [], range: NSMakeRange(0, imagePath.count))

    for match in matches {
      let url = (imagePath as NSString).substring(with: match.range)
      if let data = try? Data(contentsOf: URL(string: url)!) {
        return UIImage(data: data)
      }
    }

    if let data = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) {
      let image = UIImage(data: data)
      return image
    }

    return nil
  }
}


// MARK: - HysteriaManager - Remote Control Events
extension HysteriaManager {
  fileprivate func enableCommandCenter() {
    
    // Optional Controls
    commandCenter.changePlaybackPositionCommand.isEnabled = true
    commandCenter.changePlaybackPositionCommand.addTarget (handler: { [unowned self] event in
      let event = event as! MPChangePlaybackPositionCommandEvent
      self.seekToS(event.positionTime)
      return .success
    })
    
    // Classic Controls
    commandCenter.playCommand.isEnabled = true
    commandCenter.playCommand.addTarget (handler: { [unowned self] _ in
      self.play()
      return MPRemoteCommandHandlerStatus.success
    })

    commandCenter.pauseCommand.isEnabled = true
    commandCenter.pauseCommand.addTarget (handler: { [unowned self]  _ in
      self.pause()
      return MPRemoteCommandHandlerStatus.success
    })
    commandCenter.nextTrackCommand.isEnabled = true
    commandCenter.nextTrackCommand.addTarget (handler: { [unowned self] _ in
      self.next()
      return MPRemoteCommandHandlerStatus.success
    })

    commandCenter.previousTrackCommand.isEnabled = true
    commandCenter.previousTrackCommand.addTarget (handler: { [unowned self] _ in
      self.previous()
      return MPRemoteCommandHandlerStatus.success
    })
  }
}


// MARK: - HysteriaManager - Actions
extension HysteriaManager {

  // Play Methods
  func play() {
    let mpInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
    if (mpInfo == nil) { return }
    if !(hysteriaPlayer?.isPlaying())! {
      hysteriaPlayer?.play()
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = hysteriaPlayer?.getPlayingItemCurrentTime()
      MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyPlaybackRate] = 1
    }
  }

  func playAtIndex(_ index: Int) {
    fetchAndPlayAtIndex(index)
  }

  func playAllTracks() {
    fetchAndPlayAtIndex(0)
  }

  func pause() {
    let mpInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
    if (mpInfo == nil) { return }
    if (hysteriaPlayer?.isPlaying())! {
      hysteriaPlayer?.pause()
        
    MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = hysteriaPlayer?.getPlayingItemCurrentTime()
      MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyPlaybackRate] = 0
    }
  }

  func next() {
    hysteriaPlayer?.playNext()
  }

  func previous() {
    if let index = currentIndex() {
      hysteriaPlayer?.playPrevious()
    }
  }

  // Shuffle Methods
  func shuffleStatus() -> Bool {
    switch hysteriaPlayer?.getShuffleMode() {
    case let val where val == .on:
      return true
    case let val where val == .off:
      return false
    default:
      return false
    }
  }

  func enableShuffle() {
    hysteriaPlayer?.setPlayerShuffleMode(.on)
  }

  func disableShuffle() {
    hysteriaPlayer?.setPlayerShuffleMode(.off)
  }

  // Repeat Methods
  func repeatStatus() -> (Bool, Bool, Bool) {
    switch hysteriaPlayer?.getRepeatMode() {
    case let val where val == .on:
      return (true, false, false)
    case let val where val == .once:
      return (false, true, false)
    case let val where val == .off:
      return (false, false, true)
    default:
      return (false, false, true)
    }
  }

  func enableRepeat() {
    hysteriaPlayer?.setPlayerRepeatMode(.on)
  }

  func enableRepeatOne() {
    hysteriaPlayer?.setPlayerRepeatMode(.once)
  }

  func disableRepeat() {
    hysteriaPlayer?.setPlayerRepeatMode(.off)
  }

  func seekTo(_ slider: UISlider) {
    let duration = hysteriaPlayer?.getPlayingItemDurationTime()
    if duration!.isFinite {
      let minValue = slider.minimumValue
      let maxValue = slider.maximumValue
      let value = slider.value

      let time = duration! * (value - minValue) / (maxValue - minValue)
      hysteriaPlayer?.seek(toTime: Double(time))
    }
  }
  
  func seekToS(_ seconds: Double) {
    hysteriaPlayer?.seek(toTime: Double(seconds))
  }
  
}


// MARK: - Hysteria Playlist
extension HysteriaManager {
  func setPlaylist(_ playlist: [PlayerTrack]) {
    var nPlaylist = [PlayerTrack]()
    for (index, track) in playlist.enumerated() {
      var nTrack = track
      nTrack.position = index
      nPlaylist.append(nTrack)
    }
    
    // If reset, remove everything
    if(nPlaylist.count == 0) {
      pause()
      queue.main = [PlayerTrack]()
      return
    }
    
    let newPlaylistIds = nPlaylist.map({ $0.id })
    let previousMainQueue = queue.main.filter({ !newPlaylistIds.contains($0.id) })
    queue.main = previousMainQueue + nPlaylist
    updateCount()
    
    if (queue.main.count > 0) {
      playAtIndex(previousMainQueue.count)
    }
  }

  func addPlayNext(_ track: PlayerTrack) {
    if logs {print("• player track added :track >> \(track)")}
    var nTrack = track
    nTrack.origin = TrackType.next
    if let index = currentIndex() {
      queue.addUpNextTrack(nTrack, nowIndex: index)
      updateCount()
    }
  }
  
  fileprivate func removeHistoryTrackAtIndex(_ index: Int) {
    queue.main = queue.main.enumerated().filter({ (arg) -> Bool in
        let (tidx, element) = arg
        return tidx != index }).map({ $1 })
  }

  func playMainAtIndex(_ index: Int) {
    if let qIndex = queue.indexToPlayAt(index) {
      if queue.next.count > 0 {
        lastIndexClicked = currentIndex()!
      }
      fetchAndPlayAtIndex(qIndex)
      isClicked = true
    }
  }

  func playNextAtIndex(_ index: Int) {
    if index == 0 {
      next()
      return
    }
    if let qIndex = queue.skipToPlayAtIndex(index, nowIndex: currentIndex()!) {
      updateCount()
      fetchAndPlayAtIndex(qIndex)
    }
  }

  fileprivate func reorderHysteriaQueue() -> (_ from: Int, _ to: Int) -> Void {
    let closure: (_ from: Int, _ to: Int) -> Void = { from, to in
      self.hysteriaPlayer!.moveItem(from: from, to: to)
    }
    return closure
  }
}


// MARK: - Hysteria Utils
extension HysteriaManager {
  
  func getPlayerQueue() -> [PlayerTrack] {
    return queue.main
  }
  
  public func currentPlayerTrack() -> PlayerTrack? {
    if let index: NSNumber = hysteriaPlayer?.getHysteriaIndex(hysteriaPlayer?.getCurrentItem()) {
      let track = queue.trackAtIndex(Int(index))
      return track
    }
    return nil
  }

  func currentItem() -> AVPlayerItem! {
    return hysteriaPlayer!.getCurrentItem()
  }

  func currentIndex() -> Int? {
    if let index = hysteriaPlayer?.getHysteriaIndex(hysteriaPlayer?.getCurrentItem()) {
      return Int(index)
    }
    return nil
  }
  
  fileprivate func updateCount() {
    hysteriaPlayer?.itemsCount = hysteriaPlayerNumberOfItems()
  }

  fileprivate func fetchAndPlayAtIndex(_ index: Int) {
    hysteriaPlayer?.fetchAndPlayPlayerItem(index)
  }

  func playingItemDurationTime() -> Float {
    return hysteriaPlayer!.getPlayingItemDurationTime()
  }

  func volumeViewFrom(_ view: UIView) -> MPVolumeView! {
    return MPVolumeView(frame: view.bounds)
  }
  
  func setupPlayerItems(_ urls: [URL] ) {
    urls.enumerated().map({ (arg) -> Void in
      let (idx, url) = arg
      hysteriaPlayer?.setupPlayerItem(with: url, index: idx)
    })
  }
}

extension HysteriaManager: HysteriaPlayerDelegate {
  func hysteriaPlayerNumberOfItems() -> Int {
    return queue.totalTracks()
  }

  func hysteriaPlayerAsyncSetUrlForItem(at index: Int, preBuffer: Bool) {
    if preBuffer { return }
    
    if isClicked && lastIndexClicked != -1 {
      isClicked = false
      fetchAndPlayAtIndex(lastIndexClicked + 1)
      lastIndexClicked = -1
      return
    }
    
    if shuffleStatus() == true {
      if lastIndexShuffle != -1 {
        queue.removeNextAtIndex(lastIndexShuffle)
        hysteriaPlayer?.removeItem(at: lastIndexShuffle)
        lastIndexShuffle = -1
      }

      if let indexShuffle = queue.indexForShuffle() {
        lastIndexShuffle = indexShuffle
        hysteriaPlayer?.setupPlayerItem(with: URL(string: queue.trackAtIndex(indexShuffle).url)!, index: indexShuffle)
        return
      }
    }
    
    guard let track = queue.queueAtIndex(index) else {
      hysteriaPlayer?.removeItem(at: index - 1)
      fetchAndPlayAtIndex(index - 1)
      return
    }
    
    if(!enableTrackUrlCallbacks || track.expires > Date().addingTimeInterval(TimeInterval(30.0))) {
      hysteriaPlayer?.setupPlayerItem(with: URL(string: track.url)!, index: index)
    } else {
      playlistService?.dispatchTracksAboutToExpire(queue.main, index: index)
    }
  }
  
  func hysteriaPlayerWillChanged(at index: Int) {
    if logs {print("• player will changed :atindex >> \(index)")}
    playlistService?.dispatchTrackWillChange(index)
  }

  func hysteriaPlayerCurrentItemChanged(_ item: AVPlayerItem!) {
    if logs {print("• current item changed :item >> \(item)")}
    var currentTrack = updateCurrentItem()
    playlistService?.dispatchTrackChange(currentTrack)
  }

  func hysteriaPlayerRateChanged(_ isPlaying: Bool) {
    if logs {print("• player rate changed :isplaying >> \(isPlaying)")}
    playlistService?.dispatchPlayerStateChange(isPlaying)
  }

  func hysteriaPlayerDidReachEnd() {
    if logs {print("• player did reach end")}
    playlistService?.dispatchPlayerReachedEnd()
    
    pause()
    let lastTrack = queue.main.popLast()
    guard let lastIdx = lastTrack?.position! else { return }
    fetchAndPlayAtIndex(lastIdx)
  }

  func hysteriaPlayerCurrentItemPreloaded(_ time: CMTime) {
    if logs {print("• current item preloaded :time >> \(CMTimeGetSeconds(time))")}
    playlistService?.dispatchTrackPreloaded(time)
  }

  func hysteriaPlayerReady(_ identifier: HysteriaPlayerReadyToPlay) {
    if logs {print("• player ready to play")}
    switch identifier {
    case .currentItem:
      playlistService?.dispatchTrackPlayReady()
      updateCurrentItem()
      break
    case .player:
      playlistService?.dispatchPlayerReady()
      currentTime()
      break
    }
  }
  
  func hysteriaPlayerDidFail(_ error: Error?) {
    if logs {print("• player did failed :error >> \(error)")}
    playlistService?.dispatchPlayerFailed(error)
  }
  
  func hysteriaPlayerTrackDidFail(at index: Int, error: Error?) {
    if logs {print("• player did failed at track", index)}
    removeHistoryTrackAtIndex(index)
    playlistService?.dispatchTrackLoadFailed(error, index: index)
  }

  func hysteriaPlayerItemFailed(toPlayEndTime item: AVPlayerItem!, error: Error?) {
    if logs {print("• item failed to play end time :error >> \(error)")}
    playlistService?.dispatchTrackLoadFailed(error, index: -1)
  }

  func hysteriaPlayerItemPlaybackStall(_ item: AVPlayerItem!) {
    if logs {print("• item playback stall :item >> \(item)")}
    playlistService?.dispatchPlayerStall()
  }

}
