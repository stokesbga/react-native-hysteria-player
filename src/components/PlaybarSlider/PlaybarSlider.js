
import React from 'react'
import { Platform, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import { cleanProps } from '../propUtils'
import styles from '../styles'

const RNPlaybar = requireNativeComponent("RNPlaylistPlaybarSlider", PlaybarSlider)


export default class PlaybarSlider extends React.Component {
  render() {
    return (
      <RNPlaybar {...cleanProps(this.props, styles.wrapperNoFlex)} />
    )
  }
}