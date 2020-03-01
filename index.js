import React from 'react'
import { Platform, NativeEventEmitter, NativeModules } from 'react-native';
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource';

import * as Components from './src/components'
import PlaylistEvents, { EventTypes as AllEventTypes } from './src/events'

const { 
  RNPlaylist: Playlist,
} = NativeModules

resolveAsset = (url) => {
  if(!uri) return undefined;
  return resolveAssetSource(uri);
}

resolveUrl = (url) => {
  if(!url) return undefined;
  return resolveAssetSource(url) || url;
}

// Manager
export default Playlist

// Components 
export const PlaylistComponent = {
  ...Components
}

// Events
export const PlaylistEventEmitter = PlaylistEvents
export const EventTypes = AllEventTypes



