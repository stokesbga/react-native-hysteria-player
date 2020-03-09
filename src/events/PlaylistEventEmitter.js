import React from "react"
import { NativeEventEmitter, NativeModules } from "react-native"

//   ex. Subscribe to Events
//   PlaylistEventEmitter.addListener(
//     "onPlayerReachedEnd",
//     res => console.log("Player reached end of queue!")
//   )

const { RNPlaylistEventEmitter } = NativeModules
const PlaylistEventEmitter = new NativeEventEmitter(RNPlaylistEventEmitter)

export default PlaylistEventEmitter

export const AllEventTypes = {
  onTrackPreloaded: "onTrackPreloaded",
  onTrackWillChange: "onTrackWillChange",
  onAttemptLoadNextTrack: "onAttemptLoadNextTrack",
  onTrackChange: "onTrackChange",
  onTrackPlayReady: "onTrackPlayReady",
  onTrackPositionChange: "onTrackPositionChange",
  onTrackDurationChange: "onTrackDurationChange",
  onPlayerStateChange: "onPlayerStateChange",
  onPlayerReachedEnd: "onPlayerReachedEnd",
  onPlayerReady: "onPlayerReady",
  onPlayerStall: "onPlayerStall",
  onTrackLoadFailed: "onTrackLoadFailed",
  onPlayerFailed: "onPlayerFailed"
}
