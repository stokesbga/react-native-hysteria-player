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
@interface RCT_EXTERN_MODULE(RNPlaylistDispatcher, NSObject)
    RCT_EXTERN_METHOD(setupPlayer:
                      (RCTPromiseResolveBlock)resolve
                      rejecter:(RCTPromiseRejectBlock)reject);

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

    RCT_EXTERN_METHOD(reset:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);
@end



// Components
@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistPlayPauseButton, RNPlayPauseButton, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(playButtonImage, NSString);
    RCT_EXPORT_VIEW_PROPERTY(pauseButtonImage, NSString);
@end

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistNextPreviousButton, RNNextPreviousButton, RCTViewManager)
@end

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylistPlaybarSlider, RNPlaybarSlider, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(theme, NSDictionary);
@end



// Event Emitter
@interface RCT_EXTERN_MODULE(RNPlaylistEventEmitter, RCTEventEmitter)
@end
