
import React from 'react'
import { Platform, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import { cleanProps } from '../propUtils'
import styles from '../styles'

const RNNext = requireNativeComponent("RNPlaylistNextButton", SkipNext)


export default class SkipNext extends React.Component {
  render() {
    return (
      <RNNext {...cleanProps(this.props, styles.wrapper)} />
    )
  }
}