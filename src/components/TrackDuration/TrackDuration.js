import React from "react"
import { Platform, requireNativeComponent } from "react-native"
import PropTypes from "prop-types"
import { cleanProps } from "../propUtils"
import styles from "../styles"

const RNPlaybackDuration = requireNativeComponent(
  "RNPlaylistTimerDuration",
  PlaybackDuration
)

export default class PlaybackDuration extends React.Component {
  render() {
    return <RNPlaybackDuration {...cleanProps(this.props, styles.wrapper)} />
  }
}
