
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import styles from '../styles'

const RNNext = requireNativeComponent("RNPlaylistNextButton", SkipNext)


export default class SkipNext extends React.Component {
  render() {
    let { theme, style, ...props} = this.props;
    return (
      <RNNext 
        style={[styles.wrapper, style]}
        {...props}
      />
    )
  }
}