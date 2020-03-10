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
  
  var previous = [PlayerTrack]()
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
  
  func totalPrevTracks() -> Int {
    return previous.count
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
  mutating func reorderQueuePrevious(_ nowIndex: Int, reorderHysteria: (_ from: Int, _ to: Int) -> Void) {
    // Shuffle off
    if nowIndex <= 0 {
      if (previous.count == 0) { return }
      
      guard let previousTrack = previous.popLast() else { return }
      for i in (0...(main.count-1)).reversed() {
        reorderHysteria(i, i+1)
      }
      main.insert(previousTrack, at: 0)
    }
  
    // Shuffle On ( Desperately needs rewrite dear lord )
    var totalNext = 0
    for nTrack in main where nTrack.origin == TrackType.next {
      totalNext += 1
    }

    while totalNext != 0 {
      for (index, track) in main.reversed().enumerated() where track.origin == TrackType.next {
        main.moveItem(fromIndex: ((main.count - 1) - index), toIndex: nowIndex + 1)
        reorderHysteria(((main.count - 1) - index), nowIndex + 1)
        totalNext -= 1
        break
      }
    }
    
    playlistService?.dispatchQueueUpdate(self)
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
