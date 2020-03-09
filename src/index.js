import { Platform, NativeModules } from "react-native"

const { RNPlaylist: PlaylistModule } = NativeModules

export default PlaylistManager = {
  setup: (config = {}) => {
    PlaylistModule.setup(config)
  },

  addTracks: (tracks) => {
    const ts = tracks.map(t => ({ ...t, expires: t?.expires?.toISOString() }))
    PlaylistModule.addTracks(ts)
  },

  seekTo: (seconds = 0) => {
    PlaylistModule.seekTo(seconds)
  },

  ...PlaylistModule
}
