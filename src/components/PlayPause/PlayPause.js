
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'

const RNPlayPause = requireNativeComponent("RNPlaylistPlayPauseButton", PlayPause)


export default class PlayPause extends React.Component {
  render() {
    let { theme, ...props} = this.props;
    return (
      <RNPlayPause 
        style={{ 
          width: 100,
          height: 80 
        }}
        {...this.props} />
    )
  }
}