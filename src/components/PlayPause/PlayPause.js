import React from "react"
import { Platform, requireNativeComponent } from "react-native"
import PropTypes from "prop-types"
import { cleanProps } from "../propUtils"
import styles from "../styles"

const RNPlayPause = requireNativeComponent(
  "RNPlaylistPlayPauseButton",
  PlayPause
)

export default class PlayPause extends React.Component {
  render() {
    return <RNPlayPause {...cleanProps(this.props, styles.wrapper)} />
  }
}
