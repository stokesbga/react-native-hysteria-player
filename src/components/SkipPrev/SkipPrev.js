
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import styles from '../styles'

const RNPrev = requireNativeComponent("RNPlaylistPrevButton", SkipPrev)


export default class SkipPrev extends React.Component {
  render() {
    let { theme, style, ...props} = this.props;
    return (
      <RNPrev 
        style={[styles.wrapper, style]}
        {...props}
      />
    )
  }
}