//
//  RNPlaylist.swift
//  Playlist
//
//  Created by Alex Stokes on 2/24/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

@objc(RNPlaylist)
public class RNPlaylist: RCTEventEmitter, HysteriaPlayerDelegate, HysteriaPlayerDataSource {
    
    private var player: HysteriaPlayer?
    private lazy var playlistTracks = [Track?]()
    
    private var mRefresh: UIBarButtonItem?
    private var mTimeObserver: Any?
    private var itunesPreviewUrls: [AnyHashable]?
    private var itemsCount = 0
    private var currentTimeLabel = "0:00"
    
    private weak var playButton: UIBarButtonItem!
    private weak var pauseButton: UIBarButtonItem!
    private weak var nextButton: UIBarButtonItem!
    private weak var previousButton: UIBarButtonItem!
    private weak var toolbar: UIToolbar!
    private weak var firstButton: UIButton!
    private weak var secondButton: UIButton!
    private weak var refreshIndicator: UIActivityIndicatorView!
    
    override init() {
        super.init()
        
        // player.fetchAndPlayPlayerItem(0)
    }
      
    deinit {
        // reset(resolve: { _ in }, reject: { _, _, _  in })
    }
      
    override public static func requiresMainQueueSetup() -> Bool {
        return true;
    }
    
    @objc(setupPlayer:rejecter:)
    public func setupPlayer(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        
        var audioMedia: [String: Any] = [
         "uri": "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_1MG.mp3"
         ]
         
         var imageMedia: [String: Any] = [
           "uri": "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_weight_other/1800x1200_cat_weight_other.jpg"
         ]
         
         var track1: [String: Any] = [
             "id": "123123",
             "url": audioMedia,
             "title": "test",
             "artist": "artist",
             "album": "album",
             "artwork": imageMedia,
             "date": "10/10/20",
             "description": "bah",
             "genre": "genre",
             "duration": Double(123.023),
             "skipped": false
         ]
         
        playlistTracks = [Track(dictionary: track1)]
         
        player = HysteriaPlayer.sharedInstance()
         
        player?.delegate = self
        player?.datasource = self
        
        player?.setupPlayerItem(with: playlistTracks[0]?.url?.value, index: 0)
        
        resolve("success")
    }
    
    @objc(supportedEvents)
    override public func supportedEvents() -> [String] {
       return [
           "playback-queue-ended",
           "playback-state",
           "playback-error",
           "playback-track-changed",
           
           "remote-stop",
           "remote-pause",
           "remote-play",
           "remote-duck",
           "remote-next",
           "remote-seek",
           "remote-previous",
           "remote-jump-forward",
           "remote-jump-backward",
           "remote-like",
           "remote-dislike",
           "remote-bookmark",
       ]
    }
    
    // *** Events *** //
    public func hysteriaPlayerDidFailed(_ identifier: HysteriaPlayerFailed, error: Error?) {
        switch identifier {
        case .player:
                break
        case .currentItem:
                // Current Item failed, advanced to next.
                HysteriaPlayer.sharedInstance().playNext()
            default:
                break
        }
        print("\(error?.localizedDescription ?? "")")
    }
    
   public func playerReadyToPlay(identifier: HysteriaPlayerReadyToPlay) {
        switch(identifier) {
            case .currentItem:
                HysteriaPlayer.sharedInstance().play()
                break
            case .player:
                break;
            default:
                break
            }
       }
    
    public func hysteriaPlayerReady(_ identifier: HysteriaPlayerReadyToPlay) {
        switch identifier {
            case .player:
                if mTimeObserver == nil {
                    mTimeObserver = HysteriaPlayer.sharedInstance().addPeriodicTimeObserver(forInterval: CMTimeMake(value: 100, timescale: 1000), queue: nil /* main queue */, using: { time in
                        let totalSecond = Float(CMTimeGetSeconds(time))
                        let minute = Int(totalSecond) / 60
                        let second = Int(totalSecond) % 60
                        self.currentTimeLabel = String(format: "%02d:%02d", minute, second)
                    })
                }
        case .currentItem:
                break
            default:
                break
        }
    }
    
    public func hysteriaPlayerCurrentItemChanged(_ item: AVPlayerItem?) {
        print("current item changed")
    }

    public func hysteriaPlayerCurrentItemPreloaded(_ time: CMTime) {
        print("current item pre-loaded time: \(CMTimeGetSeconds(time))")
    }

    
    public func hysteriaPlayerDidReachEnd() {
        print("reached end of playlist")
    }
    
    public func hysteriaPlayerWillChanged(at index: Int) {
        print(String(format: "index: %li is about to play", index))
    }

    public func hysteriaPlayerNumberOfItems() -> Int {
        return itemsCount
    }


    // *** Actions *** //
    func hysteriaPlayerURLForItem(at index: Int, preBuffer: Bool) -> MediaURL? {
        return playlistTracks[index]?.artwork
    }

//    func hysteriaPlayerAsyncSetUrlForItem(at index: Int, preBuffer: Bool) {
//        if playingType == PlayingTypeAsync {
//            let urlString = String(format: "https://itunes.apple.com/lookup?amgArtistId=468749&entity=song&limit=%lu&sort=recent", UInt(itemsCount))
//            let url = URL(string: urlString)
//            var request: URLRequest? = nil
//            if let url = url {
//                request = URLRequest(url: url)
//            }
//            itunesPreviewUrls = [AnyHashable]()
//            let operation = AFJSONRequestOperation(request: request, success: { request, response, JSON in
//                    let JSONArray = (JSON as? [AnyHashable : Any])?["results"] as? [AnyHashable]
//                    for obj in JSONArray ?? [] {
//                        guard let obj = obj as? [AnyHashable : Any] else {
//                            continue
//                        }
//                        if obj["previewUrl"] != nil {
//                            itunesPreviewUrls.append(object)
//                        }
//                }
//                let url = URL(string: itunesPreviewUrls[index] as? String ?? "")
//                HysteriaPlayer.sharedInstance().setupPlayerItem(with: url, index: index)
//            })
//
//            operation.start()
//        }
//    }
    
//    func playStaticArray(_ sender: Any) {
//        let hysteriaPlayer = HysteriaPlayer.sharedInstance()
//        hysteriaPlayer?.removeAllItems()
//        itemsCount = playlistTracks.count()
//        playingType = PlayingTypeStaticItems
//
//        hysteriaPlayer?.fetchAndPlayItem(0)
//    }
    
    @objc(play:rejecter:)
    public func play(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        let hysteriaPlayer = HysteriaPlayer.sharedInstance()
//        hysteriaPlayer?.play()
        hysteriaPlayer?.fetchAndPlayPlayerItem(0)
//        hysteriaPlayer?.playNext()
        
    }
    
    @objc(pause:rejecter:)
    public func pause(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        HysteriaPlayer.sharedInstance().pause()
    }

    @objc(skipToNext:rejecter:)
    public func skipToNext(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        HysteriaPlayer.sharedInstance().playNext()
    }

    @objc(skipToPrevious:rejecter:)
    public func skipToPrevious(resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        HysteriaPlayer.sharedInstance().playPrevious()
    }
    
}
