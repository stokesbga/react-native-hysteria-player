const tracklistJSON = require('./data/hiphop_playlist_full.json')


const formatTrack = (t) => ({
  url: t.preview,
  title: t.title,
  artwork: t.album.cover_big,
  album: t.album.title,
  artist: t.artist.name,
  custom: {
    foo: "any extra data here",
    bar: ["a", "b", "c"],
  }
})

const list1 = tracklistJSON.tracks.data.slice(1, 3).map(t => formatTrack(t))
const list2 = tracklistJSON.tracks.data.slice(4, 6).map(t => formatTrack(t))


export default [[], list1, list2]