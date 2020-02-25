//
//  PlayerConvertedView.swift
//  Playlist
//
//  Created by Alex Stokes on 2/24/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


class ViewController {
    private var localMedias: [AnyHashable]?
    private var mRefresh: UIBarButtonItem?
    private var mTimeObserver: Any?
    private var itunesPreviewUrls: [AnyHashable]?

    private var itemsCount = 0
    private var playingType: PlayingType?
    @IBOutlet private weak var playButton: UIBarButtonItem!
    @IBOutlet private weak var pauseButton: UIBarButtonItem!
    @IBOutlet private weak var nextButton: UIBarButtonItem!
    @IBOutlet private weak var previousButton: UIBarButtonItem!
    @IBOutlet private weak var toolbar: UIToolbar!
    @IBOutlet private weak var firstButton: UIButton!
    @IBOutlet private weak var secondButton: UIButton!
    @IBOutlet private weak var refreshIndicator: UIActivityIndicatorView!


    func viewDidLoad() {
        super.viewDidLoad()
        initDefaults()
        localMedias = [Bundle.main.path(forResource: "pain_is_temporary", ofType: "mp3"), Bundle.main.path(forResource: "new_noise", ofType: "mp3")]

        let hysteriaPlayer = HysteriaPlayer.sharedInstance()
        hysteriaPlayer?.delegate = self
        hysteriaPlayer?.datasource = self
    }
    
    func hysteriaPlayerDidFailed(_ identifier: HysteriaPlayerFailed, error: Error?) {
        switch identifier {
            case HysteriaPlayerFailedPlayer:
                break
            case HysteriaPlayerFailedCurrentItem:
                // Current Item failed, advanced to next.
                HysteriaPlayer.sharedInstance().playNext()
            default:
                break
        }
        print("\(error?.localizedDescription ?? "")")
    }
    
    
    func hysteriaPlayerReady(_ identifier: HysteriaPlayerReadyToPlay) {
        switch identifier {
            case HysteriaPlayerReadyToPlayPlayer:
                // It will be called when Player is ready to play at the first time.

                // If you have any UI changes related to Player, should update here.

                if mTimeObserver == nil {
                    mTimeObserver = HysteriaPlayer.sharedInstance().addPeriodicTimeObserver(forInterval: CMTimeMake(value: 100, timescale: 1000), queue: nil /* main queue */, using: { time in
                        let totalSecond = Float(CMTimeGetSeconds(time))
                        let minute = Int(totalSecond) / 60
                        let second = Int(totalSecond) % 60
                        self.currentTimeLabel.text = String(format: "%02d:%02d", minute, second)
                    })
                }
            case HysteriaPlayerReadyToPlayCurrentItem:
                break
            default:
                break
        }
    }
    
    func hysteriaPlayerCurrentItemChanged(_ item: AVPlayerItem?) {
        print("current item changed")
    }

    func hysteriaPlayerCurrentItemPreloaded(_ time: CMTime) {
        print("current item pre-loaded time: \(CMTimeGetSeconds(time))")
    }

    func hysteriaPlayerDidReachEnd() {
        let alert = UIAlertView(title: "Player did reach end.", message: "", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "")
        alert.show()
    }
    
    func hysteriaPlayerRateChanged(_ isPlaying: Bool) {
        syncPlayPauseButtons()
        print("player rate changed")
    }

    func hysteriaPlayerWillChanged(at index: Int) {
        print(String(format: "index: %li is about to play", index))
    }

    func hysteriaPlayerNumberOfItems() -> Int {
        return itemsCount
    }

    
    // Adopt one of
    // hysteriaPlayerURLForItemAtIndex:(NSInteger)index
    // or
    // hysteriaPlayerAsyncSetUrlForItemAtIndex:(NSInteger)index
    // which meets your requirements.
    func hysteriaPlayerURLForItem(at index: Int, preBuffer: Bool) -> URL? {
        switch playingType {
            case PlayingTypeStaticItems:
                return URL(fileURLWithPath: localMedias[index] as? String ?? "")
            case PlayingTypeSync:
                return URL(string: itunesPreviewUrls[index] as? String ?? "")
            default:
                return nil
        }
    }

    func hysteriaPlayerAsyncSetUrlForItem(at index: Int, preBuffer: Bool) {
        if playingType == PlayingTypeAsync {
            let urlString = String(format: "https://itunes.apple.com/lookup?amgArtistId=468749&entity=song&limit=%lu&sort=recent", UInt(itemsCount))
            let url = URL(string: urlString)
            var request: URLRequest? = nil
            if let url = url {
                request = URLRequest(url: url)
            }
            itunesPreviewUrls = [AnyHashable]()
            let operation = AFJSONRequestOperation(request: request, success: { request, response, JSON in
                    let JSONArray = (JSON as? [AnyHashable : Any])?["results"] as? [AnyHashable]
                    for obj in JSONArray ?? [] {
                        guard let obj = obj as? [AnyHashable : Any] else {
                            continue
                        }
                        if obj["previewUrl"] != nil {
                            itunesPreviewUrls.append(object)
                        }
                }
                let url = URL(string: itunesPreviewUrls[index] as? String ?? "")
                HysteriaPlayer.sharedInstance().setupPlayerItem(with: url, index: index)
            })
                
            operation.start()
        }
    }
    
    @IBAction func playStaticArray(_ sender: Any) {
        let hysteriaPlayer = HysteriaPlayer.sharedInstance()
        hysteriaPlayer?.removeAllItems()
        itemsCount = localMedias.count()
        playingType = PlayingTypeStaticItems

        hysteriaPlayer?.fetchAndPlayItem(0)
    }
    
    @IBAction func play_pause(_ sender: Any) {
        let hysteriaPlayer = HysteriaPlayer.sharedInstance()

        if hysteriaPlayer?.isPlaying() != nil {
            hysteriaPlayer?.pause()
        } else {
            hysteriaPlayer?.play()
        }
    }

    @IBAction func playNext(_ sender: Any) {
        HysteriaPlayer.sharedInstance().playNext()
    }

    @IBAction func playPreviouse(_ sender: Any) {
        HysteriaPlayer.sharedInstance().playPrevious()
    }
    
    func initDefaults() {
        mRefresh = UIBarButtonItem(customView: refreshIndicator)
        mRefresh.width = 30
    }
    
    func syncPlayPauseButtons() {
        let hysteriaPlayer = HysteriaPlayer.sharedInstance()

        var toolbarItems = toolbar.items() as? [AnyHashable]
        switch hysteriaPlayer?.getStatus() {
            case HysteriaPlayerStatusUnknown:
                toolbarItems?[3] = mRefresh
            case HysteriaPlayerStatusForcePause:
                toolbarItems?[3] = playButton
            case HysteriaPlayerStatusBuffering:
                toolbarItems?[3] = playButton
            case HysteriaPlayerStatusPlaying:
                toolbarItems?[3] = pauseButton
            default:
                break
        }
        toolbar.items = toolbarItems
    }


    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
