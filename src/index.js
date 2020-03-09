import { Platform, NativeModules } from "react-native"

const { RNPlaylist: PlaylistModule } = NativeModules

export default PlaylistManager = {
  setup: (config = {}) => {
    PlaylistModule.setup(config)
  },

  seekTo: (seconds = 0) => {
    PlaylistModule.seekTo(seconds)
  },

  ...PlaylistModule
}
