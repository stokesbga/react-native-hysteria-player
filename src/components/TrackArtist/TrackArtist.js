import React from "react"
import { Platform, requireNativeComponent } from "react-native"
import PropTypes from "prop-types"
import { cleanProps } from "../propUtils"
import styles from "../styles"

const RNTrackArtist = requireNativeComponent(
  "RNPlaylistTrackArtist",
  TrackArtist
)

export default class TrackArtist extends React.Component {
  render() {
    return <RNTrackArtist {...cleanProps(this.props, styles.wrapper)} />
  }
}

TrackArtist.defaultProps = {
  marqueeSpeed: 60,
  marqueeDelay: 1.0,
  marqueeFadeLength: 50,
  marqueeTrailingMargin: 50
}
