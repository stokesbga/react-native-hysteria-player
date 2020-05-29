package com.quadiomedia.RNPlaylist;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.facebook.react.bridge.JavaScriptModule;

public class PlaylistPackage implements ReactPackage {
    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        return Arrays.<NativeModule>asList(
            new PlaylistManager(reactContext)
        );
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Arrays.<ViewManager>asList(
            new RNPlaybarSlider(),
            new RNPlayPauseButton(),
            new RNSkipNextButton(),
            new RNSkipPrevButton(),
            new RNTimerDuration(),
            new RNTimerProgress(),
            new RNTrackAlbumArt(),
            new RNTrackAlbumArtSwiper(),
            new RNTrackArtist(),
            new RNTrackTitle()
        );
    }
}
