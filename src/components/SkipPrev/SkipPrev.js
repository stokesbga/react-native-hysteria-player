
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'

const RNPrev = requireNativeComponent("RNPlaylistPrevButton", SkipPrev)


export default class SkipPrev extends React.Component {
  render() {
    let { theme, ...props} = this.props;
    return (
      <RNPrev 
        style={{ 
          width: 100,
          height: 80 
        }}
        {...this.props}
      />
    )
  }
}