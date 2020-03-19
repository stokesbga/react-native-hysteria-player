import React from "react"
import { Platform, requireNativeComponent } from "react-native"
import PropTypes from "prop-types"
import { cleanProps } from "../propUtils"
import styles from "../styles"

const RNTrackAlbumArtSwiper = requireNativeComponent(
  "RNPlaylistAlbumArtSwiper",
  TrackAlbumArtSwiper
)

export default class TrackAlbumArtSwiper extends React.Component {
  render() {
    return <RNTrackAlbumArtSwiper {...cleanProps(this.props, styles.wrapperNoFlex)} />
  }
}
