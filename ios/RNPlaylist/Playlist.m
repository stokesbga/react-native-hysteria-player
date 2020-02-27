#import "Playlist.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <React/RCTEventEmitter.h>

// Classes

@interface RCT_EXTERN_REMAP_MODULE(RNPlaylist, RNPlaylistManager, RCTEventEmitter)
    - (dispatch_queue_t)methodQueue
    {
      return dispatch_get_main_queue();
    }


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


// Views
@interface RCT_EXTERN_REMAP_MODULE(RNPlaybar, RNPlaybarViewManager, RCTViewManager)
    RCT_EXPORT_VIEW_PROPERTY(theme, NSDictionary);
@end
