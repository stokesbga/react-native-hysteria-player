package com.quadiomedia.RNPlaylist;

import android.view.View;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;


public class RNTrackAlbumArt extends SimpleViewManager<View> {

    @Override
    public String getName() {
        return "RNPlaylistAlbumArt";
    }

    @Override
    protected View createViewInstance(ThemedReactContext reactContext) {
        return new View(reactContext);
    }
}