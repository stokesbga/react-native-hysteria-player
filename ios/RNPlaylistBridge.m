//
//  AudioPlayer.m
//  RnPlaylist
//
//  Created by Alex Stokes on 2/24/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "RNPlaylistBridge.h"

#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>

// Classes
@interface RCT_EXTERN_MODULE(AudioPlayer, NSObject)
   RCT_EXTERN_METHOD(playSound:(NSString *)url)
@end


// Views
@interface RCT_EXTERN_MODULE(PlayerControls, RCTViewManager)
@end
