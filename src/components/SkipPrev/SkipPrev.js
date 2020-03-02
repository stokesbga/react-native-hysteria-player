
import React from 'react'
import { Platform, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import { cleanProps } from '../propUtils'
import styles from '../styles'

const RNPrev = requireNativeComponent("RNPlaylistPrevButton", SkipPrev)


export default class SkipPrev extends React.Component {
  render() {
    return (
      <RNPrev {...cleanProps(this.props, styles.wrapper)} />
    )
  }
}