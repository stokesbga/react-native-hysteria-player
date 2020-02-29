import React from 'react'
import { Platform, DeviceEventEmitter, NativeEventEmitter, NativeModules } from 'react-native';
import * as Components from './src/components'

const { 
  RNPlaylist: Playlist, 
  RNPlaylistEventEmitter
} = NativeModules

export default Playlist
export const PlaylistEventEmitter = new NativeEventEmitter(RNPlaylistEventEmitter)

// Subscribe to Events
PlaylistEventEmitter.addListener(
  "playback-state",
  res => console.log("Playback state change: ", res)
)

// Components 
export const PlaylistComponent = {
  ...Components
}



