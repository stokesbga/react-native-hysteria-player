#import "Playlist.h"
#import <React/RCTBridgeModule.h>

// Classes

@interface RCT_EXTERN_MODULE(RNPlaylist, NSObject)

    RCT_EXTERN_METHOD(setupPlayer:
                      (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject);

    RCT_EXTERN_METHOD(skipToNext:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);

    RCT_EXTERN_METHOD(skipToPrevious:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);

//   RCT_EXTERN_METHOD(reset:(RCTPromiseResolveBlock)resolve
//                     rejecter:(RCTPromiseRejectBlock)reject);

    RCT_EXTERN_METHOD(play:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);

    RCT_EXTERN_METHOD(pause:(RCTPromiseResolveBlock)resolve
                     rejecter:(RCTPromiseRejectBlock)reject);
@end


// Views
//@interface RCT_EXTERN_MODULE(PlayerControls, RCTViewManager)
//@end
