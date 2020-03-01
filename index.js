import React from 'react'
import { Platform, DeviceEventEmitter, NativeEventEmitter, NativeModules } from 'react-native';
import * as Components from './src/components'
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource';

const { 
  RNPlaylist: Playlist, 
  RNPlaylistEventEmitter
} = NativeModules

resolveAsset = (url) => {
  if(!uri) return undefined;
  return resolveAssetSource(uri);
}

resolveUrl = (url) => {
  if(!url) return undefined;
  return resolveAssetSource(url) || url;
}

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



