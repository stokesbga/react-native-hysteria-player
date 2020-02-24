
# react-native-playlist

## Getting started

`$ npm install react-native-playlist --save`

### Mostly automatic installation

`$ react-native link react-native-playlist`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-playlist` and add `RNPlaylist.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNPlaylist.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.quadiomedia.rnplaylist.RNPlaylistPackage;` to the imports at the top of the file
  - Add `new RNPlaylistPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-playlist'
  	project(':react-native-playlist').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-playlist/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-playlist')
  	```


## Usage
```javascript
import RNPlaylist from 'react-native-playlist';

// TODO: What to do with the module?
RNPlaylist;
```
  