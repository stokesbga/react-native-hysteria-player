
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import { textAlignFormat } from '../propUtils'
import styles from '../styles'

const RNTrackTitle = requireNativeComponent("RNPlaylistTrackTitle", TrackTitle)


export default class TrackTitle extends React.Component {
  render() {
    const { color, textAlign, style, ...props } = this.props
    return (
      <RNTrackTitle 
        style={[styles.wrapper, style]}
        color={processColor(color)}
        textAlign={textAlignFormat(textAlign)}
        {...props} />
    )
  }
}