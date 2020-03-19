//
//  SwiftPlayerQueue.swift
//  Pods
//
//  Created by Ítalo Sangar on 4/8/16.
//
//

import Foundation

struct PlayerQueue {
  var playlistService = PlaylistService.shared
  
  var next = [PlayerTrack]()
  var main = [PlayerTrack]() {
    didSet {
      playlistService?.dispatchQueueUpdate(self)
    }
  }
  
  ///////////////////////////////////////////////
  func totalTracks() -> Int {
    return main.count
  }
  
  ///////////////////////////////////////////////
  mutating func addUpNextTrack(_ track: PlayerTrack, nowIndex: Int) {
    main.insert(track, at: nowIndex + 1)
    next.insert(track, at: 0)
    playlistService?.dispatchQueueUpdate(self)
  }
  
  ///////////////////////////////////////////////
  mutating func removeNextAtIndex(_ index: Int) {
    main.remove(at: index)
    next.remove(at: 0)
    playlistService?.dispatchQueueUpdate(self)
  }
  
  ///////////////////////////////////////////////
  mutating func queueAtIndex(_ index: Int) -> PlayerTrack? {
    if index > 0 && main[index - 1].origin == TrackType.next {
      main.remove(at: index - 1)
      next.remove(at: 0)
      playlistService?.dispatchQueueUpdate(self)
      return nil
    }

    return main[index]
  }
  
  ///////////////////////////////////////////////
  func indexForShuffle() -> Int? {
    for (index, track) in main.enumerated() where track.origin == TrackType.next {
      return index
    }
    return nil
  }

  ///////////////////////////////////////////////
  func indexToPlayAt(_ indexMain: Int) -> Int? {
    for (index, track) in main.enumerated() where track.origin == TrackType.normal && track.position == indexMain {
      return index
    }
    return nil
  }
  
  ///////////////////////////////////////////////
  mutating func skipToPlayAtIndex(_ indexNext: Int, nowIndex: Int) -> Int? {
    var indexOnQueue = 0
    var firstFound = 0
    var totalFound = 0
    
    for (index, track) in main.enumerated() where track.origin == TrackType.next {
      firstFound = index
      indexOnQueue = index + indexNext
      break
    }
    
    for i in 0..<indexOnQueue {
      if main[i].origin == TrackType.next {
        totalFound += 1
      }
    }
    
    if main[nowIndex].origin == TrackType.next {
      firstFound += 1
      indexOnQueue += 1
    }
    
    main.removeSubrange(firstFound...(indexOnQueue - 1))
    
    for _ in firstFound...(indexOnQueue - 1) {
      next.remove(at: 0)
    }
    
    playlistService?.dispatchQueueUpdate(self)
    return indexOnQueue - totalFound
  }
  
  ///////////////////////////////////////////////
  func trackAtIndex(_ index: Int) -> PlayerTrack {
    return main[index]
  }
}


extension Array {
  mutating func moveItem(fromIndex oldIndex: Index, toIndex newIndex: Index) {
    insert(remove(at: oldIndex), at: newIndex)
  }
}
