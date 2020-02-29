
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'

const RNNext = requireNativeComponent("RNPlaylistNextButton", SkipNext)


export default class SkipNext extends React.Component {
  render() {
    let { theme, ...props} = this.props;
    return (
      <RNNext 
        style={{ 
          width: 100,
          height: 80 
        }}
        {...this.props}
      />
    )
  }
}