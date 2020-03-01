
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import styles from '../styles'

const RNPlayPause = requireNativeComponent("RNPlaylistPlayPauseButton", PlayPause)


export default class PlayPause extends React.Component {
  render() {
    let { theme, style, ...props} = this.props;
    return (
      <RNPlayPause 
        style={[styles.wrapper, style]}
        {...props} />
    )
  }
}