
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import { cleanProps } from '../propUtils'
import styles from '../styles'

const RNPlaybackProgress = requireNativeComponent("RNPlaylistTimerProgress", PlaybackProgress)


export default class PlaybackProgress extends React.Component {
  render() {
    return (
      <RNPlaybackProgress {...cleanProps(this.props, styles.wrapper)} />
    )
  }
}