//
//  Playlist.m
//  Playlist
//
//  Created by Alex Stokes on 2/25/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "Playlist.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <React/RCTEventEmitter.h>


// Controller
@interface RCT_EXTERN_MODULE(RNPlaylist, NSObject)
    RCT_EXTERN_METHOD(setup:(NSDictionary)config);

    RCT_EXTERN_METHOD(teardown:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);
    
    RCT_EXTERN_METHOD(addTracks:(NSArray)tracks);

    RCT_EXTERN_METHOD(getCurrentTrack:(RCTPromiseResolveBlock)resolve
                      rejecter:(RCTPromiseRejectBlock)reject);

    RCT_EXTERN_METHOD(refreshTrackURLs:(NSArray)urls);

    RCT_EXTERN_METHOD(play:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);

    RCT_EXTERN_METHOD(pause:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);

    RCT_EXTERN_METHOD(togglePlay:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);

    RCT_EXTERN_METHOD(skipToNext:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);

    RCT_EXTERN_METHOD(skipToPrevious:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);

    RCT_EXTERN_METHOD(seekTo:(nonnull NSNumber *)seconds);
    
    RCT_EXTERN_METHOD(toggleShuffle:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);
@end



// Components
@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistPlaybarSlider, RNPlaybarSlider, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(hasControl, BOOL);
    RCT_EXPORT_VIEW_PROPERTY(thumbRadius, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(trackHeightEnabled, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(trackHeightDisabled, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(trackPlayedColor, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(trackRemainingColor, NSNumber);
@end

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistPlayPauseButton, RNPlayPauseButton, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(disabledOpacity, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(playIcon, NSString);
    RCT_EXPORT_VIEW_PROPERTY(pauseIcon, NSString);
    RCT_EXPORT_VIEW_PROPERTY(color, NSNumber);
@end

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistNextButton, RNSkipNextButton, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(disabledOpacity, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(icon, NSString);
    RCT_EXPORT_VIEW_PROPERTY(color, NSNumber);
@end

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistPrevButton, RNSkipPrevButton, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(disabledOpacity, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(icon, NSString);
    RCT_EXPORT_VIEW_PROPERTY(color, NSNumber);
@end

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistAlbumArt, RNTrackAlbumArt, RCTViewManager)
@end

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistTimerDuration, RNTimerDuration, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(fontFamily, NSString);
    RCT_EXPORT_VIEW_PROPERTY(fontSize, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(color, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(textAlign, NSNumber);
@end

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistTimerProgress, RNTimerProgress, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(fontFamily, NSString);
    RCT_EXPORT_VIEW_PROPERTY(fontSize, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(color, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(textAlign, NSNumber);
@end

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistTrackArtist, RNTrackArtist, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(fontFamily, NSString);
    RCT_EXPORT_VIEW_PROPERTY(fontSize, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(color, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(textAlign, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(marqueeSpeed, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(marqueeDelay, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(marqueeFadeLength, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(marqueeTrailingMargin, NSNumber);
@end

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistTrackTitle, RNTrackTitle, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(fontFamily, NSString);
    RCT_EXPORT_VIEW_PROPERTY(fontSize, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(color, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(textAlign, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(marqueeSpeed, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(marqueeDelay, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(marqueeFadeLength, NSNumber);
    RCT_EXPORT_VIEW_PROPERTY(marqueeTrailingMargin, NSNumber);
@end



// Event Emitter
@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistEventEmitter, RNPlaylistService, RCTEventEmitter)
@end
