
package com.quadiomedia.rnplaylist;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class RNPlaylistModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNPlaylistModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNPlaylist";
  }
}