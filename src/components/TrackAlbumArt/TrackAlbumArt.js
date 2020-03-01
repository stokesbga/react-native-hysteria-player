
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import styles from '../styles'

const RNTrackAlbumArt = requireNativeComponent("RNPlaylistAlbumArt", TrackAlbumArt)


export default class TrackAlbumArt extends React.Component {
  render() {
    const { style, ...props } = this.props
    return (
      <RNTrackAlbumArt 
        style={[styles.wrapperNoFlex, style]}
        {...props} />
    )
  }
}