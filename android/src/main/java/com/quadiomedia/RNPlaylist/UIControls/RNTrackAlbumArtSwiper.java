package com.quadiomedia.RNPlaylist;

import android.view.View;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;


public class RNTrackAlbumArtSwiper extends SimpleViewManager<View> {

    @Override
    public String getName() {
        return "RNPlaylistAlbumArtSwiper";
    }

    @Override
    protected View createViewInstance(ThemedReactContext reactContext) {
        return new View(reactContext);
    }
}