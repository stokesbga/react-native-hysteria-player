import React from 'react'
import { Platform, NativeEventEmitter, NativeModules } from 'react-native';
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource';

import * as Components from './src/components'
import PlaylistEvents, { EventTypes as AllEventTypes } from './src/events'
import PlaylistManager from './src'


// Manager
export default PlaylistManager

// Components 
export const PlaylistComponent = {
  ...Components
}

// Events
export const PlaylistEventEmitter = PlaylistEvents
export const EventTypes = AllEventTypes



