//
//  PolyvLiveWatchRnModule.h
//  test
//
//  Created by 李长杰 on 2019/2/14.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PolyvLiveWatchRnErrorCode) {
  PolyvLiveWatchRnError_Success = 0,
  PolyvLiveWatchRnError_NoAppId = -1,
  PolyvLiveWatchRnError_NoAppSecret = -2,
  PolyvLiveWatchRnError_NoViewerId = -3,
  PolyvLiveWatchRnError_NoUserId = -4,
  PolyvLiveWatchRnError_NoChannelId = -5,
  PolyvLiveWatchRnError_ChannelLoginFailed = -6,
};

@interface PolyvLiveRnModule : NSObject <RCTBridgeModule>

@end

NS_ASSUME_NONNULL_END
