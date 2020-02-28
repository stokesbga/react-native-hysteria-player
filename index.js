import React from 'react'
import { Platform, AppRegistry, DeviceEventEmitter, NativeEventEmitter, NativeModules, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'

const { 
  RNPlaylistDispatcher: Playlist, 
  RNPlaylistEventEmitter
} = NativeModules

export default Playlist
export const PlaylistEventEmitter = new NativeEventEmitter(RNPlaylistEventEmitter)

// Subscribe to events
PlaylistEventEmitter.addListener(
  "playback-state",
  res => console.log("Playback state change: ", res)
)

const RNNextPrevious = requireNativeComponent("RNPlaylistNextPreviousButton", SkipButtons)
const RNPlayPause = requireNativeComponent("RNPlaylistPlayPauseButton", PlayPause)
const RNPlaybar = requireNativeComponent("RNPlaylistPlaybarSlider", Playbar)


export class Playbar extends React.Component {
  render() {
    let { theme, ...props} = this.props;
    return (
      <RNPlaybar 
        theme={{
          trackPlayedColor: processColor(theme.trackPlayedColor),
          trackRemainingColor: processColor(theme.trackRemainingColor)
        }} {...props} />
    )
  }
}

export class PlayPause extends React.Component {
  render() {
    return (
      <RNPlayPause style={{ backgroundColor: 'coral', width: 100, height: 100 }} {...this.props} />
    )
  }
}

export class SkipButtons extends React.Component {
  render() {
    return (
      <RNNextPrevious 
        style={{ 
          backgroundColor: 'lightgreen',
          width: 100,
          height: 80 
        }}
        {...this.props}
      />
    )
  }
}

