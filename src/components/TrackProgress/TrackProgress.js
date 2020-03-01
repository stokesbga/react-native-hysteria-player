
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import styles from '../styles'

const RNPlaybackProgress = requireNativeComponent("RNPlaylistTimerProgress", PlaybackProgress)


export default class PlaybackProgress extends React.Component {
  render() {
    const { style, ...props } = this.props
    return (
      <RNPlaybackProgress 
        style={[styles.wrapper, style]}
        {...props} />
    )
  }
}