
import React from 'react'
import { Platform, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'
import styles from '../styles'

const RNPlaybar = requireNativeComponent("RNPlaylistPlaybarSlider", PlaybarSlider)


export default class PlaybarSlider extends React.Component {
  render() {
    let { trackPlayedColor, trackRemainingColor, style, ...props} = this.props;
    return (
      <RNPlaybar 
        {...props}
        style={[styles.wrapperNoFlex, style]}
        trackPlayedColor={processColor(trackPlayedColor)}
        trackRemainingColor={processColor(trackRemainingColor)} />
    )
  }
}


// hasControl={this.state.switch}
// thumbRadius={20}
// trackHeightEnabled={20}
// trackHeightDisabled={10}
// trackPlayedColor={this.state.color1}
// trackRemainingColor={this.state.color2}
// style={{
// backgroundColor: '#f0f0f0',
// }}