
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import styles from '../styles'

const RNTrackTitle = requireNativeComponent("RNPlaylistTrackTitle", TrackTitle)


export default class TrackTitle extends React.Component {
  render() {
    const { style, ...props } = this.props
    return (
      <RNTrackTitle 
        style={[styles.wrapper, style]}
        {...props} />
    )
  }
}