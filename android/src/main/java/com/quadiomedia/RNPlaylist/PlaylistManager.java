package com.quadiomedia.RNPlaylist;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

public class PlaylistManager extends ReactContextBaseJavaModule {
    
    // Config static vars
    public static String emptyTrackTitle = "None";
    public static String emptyArtistTitle = "None";

    public PlaylistManager(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNPlaylist";
    }

    /** 
     * API Methods *
     */ 
    @ReactMethod
    public void setup(ReadableMap config) {

    }

    @ReactMethod
    public void teardown(Promise promise) {

    }

    @ReactMethod
    public void addTracks(ReadableArray tracks) {

    }

    @ReactMethod
    public void getCurrentTrack(Promise promise) {

    }

    @ReactMethod
    public void refreshTrackURLs(ReadableArray urls) {

    }

    @ReactMethod
    public void play(Promise promise) {

    }

    @ReactMethod
    public void pause(Promise promise) {

    }

    @ReactMethod
    public void togglePlay(Promise promise) {

    }

    @ReactMethod
    public void skipToNext(Promise promise) {

    }

    @ReactMethod
    public void skipToPrevious(Promise promise) {

    }

    @ReactMethod
    public void seekTo(Double seconds ) {

    }

    @ReactMethod
    public void toggleShuffle(Promise promise) {

    }
}
