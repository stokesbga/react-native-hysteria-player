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

  var logs = true
  var queue = PlayerQueue()
  var delegate: SwiftPlayerDelegate?
  var controller: UIViewController?
  var queueDelegate: SwiftPlayerQueueDelegate?

  fileprivate let commandCenter = MPRemoteCommandCenter.shared()
  fileprivate var isClicked = false
  fileprivate var lastIndexClicked = -1
  fileprivate var lastIndexShuffle = -1


  fileprivate override init() {
    super.init()
    initHysteriaPlayer()
  }

  fileprivate func initHysteriaPlayer() {
    hysteriaPlayer?.delegate = self;
    hysteriaPlayer?.datasource = self;
    hysteriaPlayer?.enableMemoryCached(false)
    enableCommandCenter()

  }
}


// MARK: - HysteriaManager - UI
extension HysteriaManager {
  fileprivate func currentTime() {
    hysteriaPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 100, timescale: 1000), queue: nil, using: {
      time in
      let totalSeconds = CMTimeGetSeconds(time)
      self.delegate?.playerCurrentTimeChanged(Float(totalSeconds))
    })
  }

  fileprivate func updateCurrentItem() {
    infoCenterWithTrack(currentItem())

    let duration = hysteriaPlayer?.getPlayingItemDurationTime()
    if duration > 0 {
      delegate?.playerDurationTime(duration!)
    }
  }

}


// MARK: - HysteriaManager - MPNowPlayingInfoCenter
extension HysteriaManager {

  func updateImageInfoCenter(_ image: UIImage) {
    if var dictionary = MPNowPlayingInfoCenter.default().nowPlayingInfo {
      dictionary[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
    }
  }

  fileprivate func infoCenterWithTrack(_ track: PlayerTrack?) {
    guard let track = track else { return }

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
    }

    MPNowPlayingInfoCenter.default().nowPlayingInfo = dictionary
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
    commandCenter.playCommand.addTarget (handler: { _ in
      self.play()
      return MPRemoteCommandHandlerStatus.success
    })

    commandCenter.pauseCommand.addTarget (handler: { _ in
      self.pause()
      return MPRemoteCommandHandlerStatus.success
    })

    commandCenter.nextTrackCommand.addTarget (handler: { _ in
      self.next()
      return MPRemoteCommandHandlerStatus.success
    })

    commandCenter.previousTrackCommand.addTarget (handler: { _ in
      self.previous()
      return MPRemoteCommandHandlerStatus.success
    })
  }
}


// MARK: - HysteriaManager - Actions
extension HysteriaManager {

  // Play Methods
  func play() {
    if !(hysteriaPlayer?.isPlaying())! {
      hysteriaPlayer?.play()
    }
  }

  func playAtIndex(_ index: Int) {
    fetchAndPlayAtIndex(index)
  }

  func playAllTracks() {
    fetchAndPlayAtIndex(0)
  }

  func pause() {
    if (hysteriaPlayer?.isPlaying())! {
      hysteriaPlayer?.pause()
    }
  }

  func next() {
    hysteriaPlayer?.playNext()
  }

  func previous() {
    if let index = currentIndex() {
      queue.reorderQueuePrevious(index - 1, reorderHysteria: reorderHysteryaQueue())
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
    queue.mainQueue = nPlaylist
  }

  func addPlayNext(_ track: PlayerTrack) {
    if logs {print("• player track added :track >> \(track)")}
    var nTrack = track
    nTrack.origin = TrackType.next
    if let index = currentIndex() {
      queue.newNextTrack(nTrack, nowIndex: index)
      updateCount()
    }
  }

  fileprivate func addHistoryTrack(_ track: PlayerTrack) {
    queue.history.append(track)
  }

  func playMainAtIndex(_ index: Int) {
    if let qIndex = queue.indexToPlayAt(index) {
      if queue.nextQueue.count > 0 {
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
    if let qIndex = queue.indexToPlayNextAt(index, nowIndex: currentIndex()!) {
      updateCount()
      fetchAndPlayAtIndex(qIndex)
    }
  }

  fileprivate func reorderHysteryaQueue() -> (_ from: Int, _ to: Int) -> Void {
    let closure: (_ from: Int, _ to: Int) -> Void = { from, to in
      self.hysteriaPlayer!.moveItem(from: from, to: to)
    }
    return closure
  }
}


// MARK: - Hysteria Utils
extension HysteriaManager {
  fileprivate func updateCount() {
    hysteriaPlayer?.itemsCount = hysteriaPlayerNumberOfItems()
  }

  fileprivate func currentItem() -> PlayerTrack? {
    if let index: NSNumber = hysteriaPlayer?.getHysteriaIndex(hysteriaPlayer?.getCurrentItem()) {
      let track = queue.trackAtIndex(Int(index))
      addHistoryTrack(track)
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

  fileprivate func fetchAndPlayAtIndex(_ index: Int) {
    hysteriaPlayer?.fetchAndPlayPlayerItem(index)
  }

  func playingItemDurationTime() -> Float {
    return hysteriaPlayer!.getPlayingItemDurationTime()
  }

  func volumeViewFrom(_ view: UIView) -> MPVolumeView! {
    return MPVolumeView(frame: view.bounds)
  }
}


// MARK: - HysteriaPlayerDataSource
extension HysteriaManager: HysteriaPlayerDataSource {
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

      if let indexShufle = queue.indexForShuffle() {
        lastIndexShuffle = indexShufle
        hysteriaPlayer?.setupPlayerItem(with: URL(string: queue.trackAtIndex(indexShufle).url)!, index: indexShufle)
        return
      }
    }

    guard let track = queue.queueAtIndex(index) else {
      hysteriaPlayer?.removeItem(at: index - 1)
      fetchAndPlayAtIndex(index - 1)
      return
    }

    hysteriaPlayer?.setupPlayerItem(with: URL(string: track.url)!, index: index)
  }
}


// MARK: - HysteriaPlayerDelegate
extension HysteriaManager: HysteriaPlayerDelegate {

  func hysteriaPlayerWillChanged(at index: Int) {
    if logs {print("• player will changed :atindex >> \(index)")}
  }

  func hysteriaPlayerCurrentItemChanged(_ item: AVPlayerItem!) {
    if logs {print("• current item changed :item >> \(item)")}
    delegate?.playerCurrentTrackChanged(currentItem())
    queueDelegate?.queueUpdated()
    updateCurrentItem()
  }

  func hysteriaPlayerRateChanged(_ isPlaying: Bool) {
    if logs {print("• player rate changed :isplaying >> \(isPlaying)")}
    delegate?.playerRateChanged(isPlaying)
  }

  func hysteriaPlayerDidReachEnd() {
    if logs {print("• player did reach end")}
  }

  func hysteriaPlayerCurrentItemPreloaded(_ time: CMTime) {
    if logs {print("• current item preloaded :time >> \(CMTimeGetSeconds(time))")}
  }

  func hysteriaPlayerDidFailed(_ identifier: HysteriaPlayerFailed, error: NSError!) {
    if logs {print("• player did failed :error >> \(error.description)")}
    switch identifier {
    case .currentItem: next()
      break
    case .player:
      break
    }
  }

  func hysteriaPlayerReady(_ identifier: HysteriaPlayerReadyToPlay) {
    if logs {print("• player ready to play")}
    switch identifier {
    case .currentItem: updateCurrentItem()
      break
    case .player: currentTime()
      break
    }
  }

  func hysteriaPlayerItemFailed(toPlayEndTime item: AVPlayerItem!, error: NSError!) {
    if logs {print("• item failed to play end time :error >> \(error.description)")}
  }

  func hysteriaPlayerItemPlaybackStall(_ item: AVPlayerItem!) {
    if logs {print("• item playback stall :item >> \(item)")}
  }

}
