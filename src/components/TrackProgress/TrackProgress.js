
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'

const RNPlaybackProgress = requireNativeComponent("RNPlaylistTimerProgress", PlaybackProgress)


export default class PlaybackProgress extends React.Component {
  render() {
    return (
      <RNPlaybackProgress 
      style={{ 
        width: 100,
        height: 80 
      }}
      {...this.props} />
    )
  }
}