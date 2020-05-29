package com.quadiomedia.RNPlaylist;

import android.view.View;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;


public class RNPlayPauseButton extends SimpleViewManager<View> {

    @Override
    public String getName() {
        return "RNPlaylistPlayPauseButton";
    }

    @Override
    protected View createViewInstance(ThemedReactContext reactContext) {
        return new View(reactContext);
    }
}