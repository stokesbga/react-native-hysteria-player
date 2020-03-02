
import React from 'react'
import { Platform, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import { cleanProps } from '../propUtils'
import styles from '../styles'

const RNTrackAlbumArt = requireNativeComponent("RNPlaylistAlbumArt", TrackAlbumArt)


export default class TrackAlbumArt extends React.Component {
  render() {
    return (
      <RNTrackAlbumArt {...cleanProps(this.props, styles.wrapperNoFlex)} />
    )
  }
}