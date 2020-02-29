
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'

const RNPlaybackDuration = requireNativeComponent("RNPlaylistTimerDuration", PlaybackDuration)


export default class PlaybackDuration extends React.Component {
  render() {
    return (
      <RNPlaybackDuration 
        style={{ 
          width: 100,
          height: 80 
        }}
        {...this.props} />
    )
  }
}