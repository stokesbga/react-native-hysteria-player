import React from 'react'
import { Platform, AppRegistry, DeviceEventEmitter, NativeEventEmitter, NativeModules, processColor, requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types'

const { RNPlaylist: Playlist } = NativeModules
const RNPlaybar = requireNativeComponent("RNPlaybar", Playbar)


export class Playbar extends React.Component {
  render() {
    let { theme, ...props} = this.props;
    return (
      <RNPlaybar 
        theme={{
          trackPlayedColor: processColor(theme.trackPlayedColor),
          trackRemainingColor: processColor(theme.trackRemainingColor)
        }} {...props} />
    )
    // return <RNPlaybar {...props} />
  }
}

Playbar.propTypes = {
  theme: PropTypes.object
}

export default Playlist

