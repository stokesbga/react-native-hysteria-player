import React from 'react'
import { Platform, AppRegistry, DeviceEventEmitter, NativeEventEmitter, NativeModules, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'

const { 
  RNPlaylist: Playlist, 
  RNPlaylistEventEmitter
} = NativeModules

export default Playlist
export const PlaylistEventEmitter = new NativeEventEmitter(RNPlaylistEventEmitter)

// Subscribe to events
PlaylistEventEmitter.addListener(
  "playback-state",
  res => console.log("Playback state change: ", res)
)

const RNPrev = requireNativeComponent("RNPlaylistPrevButton", SkipPrev)
const RNNext = requireNativeComponent("RNPlaylistNextButton", SkipNext)
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
      <RNPlayPause 
        style={{ 
          backgroundColor: 'lightgreen',
          width: 100,
          height: 80 
        }}
        {...this.props} />
    )
  }
}

export class SkipPrev extends React.Component {
  render() {
    return (
      <RNPrev 
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

export class SkipNext extends React.Component {
  render() {
    return (
      <RNNext 
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

