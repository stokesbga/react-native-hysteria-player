
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import styles from '../styles'

const RNPlaybackDuration = requireNativeComponent("RNPlaylistTimerDuration", PlaybackDuration)


export default class PlaybackDuration extends React.Component {
  render() {
    const { style, ...props } = this.props
    return (
      <RNPlaybackDuration 
        style={[styles.wrapper, style]}
        {...props} />
    )
  }
}