package com.quadiomedia.RNPlaylist;

import android.view.View;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;


public class RNSkipPrevButton extends SimpleViewManager<View> {

    @Override
    public String getName() {
        return "RNPlaylistPrevButton";
    }

    @Override
    protected View createViewInstance(ThemedReactContext reactContext) {
        return new View(reactContext);
    }
}