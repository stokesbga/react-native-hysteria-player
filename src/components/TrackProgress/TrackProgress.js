
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import { textAlignFormat } from '../propUtils'
import styles from '../styles'

const RNPlaybackProgress = requireNativeComponent("RNPlaylistTimerProgress", PlaybackProgress)


export default class PlaybackProgress extends React.Component {
  render() {
    const { color, textAlign, style, ...props } = this.props
    return (
      <RNPlaybackProgress 
        style={[styles.wrapper, style]}
        color={processColor(color)}
        textAlign={textAlignFormat(textAlign)}
        {...props} />
    )
  }
}