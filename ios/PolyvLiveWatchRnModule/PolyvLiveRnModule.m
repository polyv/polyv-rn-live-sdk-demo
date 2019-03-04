//
//  PolyvLiveWatchRnModule.m
//  test
//
//  Created by 李长杰 on 2019/2/14.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "PolyvLiveRnModule.h"
#import "LivePlayerViewController.h"
#import <PLVLiveAPI/PLVLiveConfig.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <React/RCTUIManager.h>
#import <React/UIView+React.h>

NSString * NSStringFromPolyvLiveWatchRnError(PolyvLiveWatchRnErrorCode code) {
  switch (code) {
    case PolyvLiveWatchRnError_Success:
      return @"成功";
    case PolyvLiveWatchRnError_NoAppId:
      return @"AppId为空";
    case PolyvLiveWatchRnError_NoAppSecret:
      return @"AppSecret为空";
    case PolyvLiveWatchRnError_NoViewerId:
      return @"viewerId为空";
    case PolyvLiveWatchRnError_NoUserId:
      return @"UserId为空";
    case PolyvLiveWatchRnError_NoChannelId:
      return @"ChannelId为空";
    case PolyvLiveWatchRnError_ChannelLoginFailed:
      return @"频道加载失败";
    default:
      return @"";
  }
}

@interface PolyvLiveRnModule ()

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *avatar;

@end

@implementation PolyvLiveRnModule

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

// 参数 appId (必填)
// 参数 appSecret (必填)
// 参数 viewerId（必填）
// 参数 nickName（选填）
// 参数 avatar（选填）
RCT_EXPORT_METHOD(init:(NSString *)appId
                  appSecret:(NSString *)appSecret
                  viewerId:(NSString *)viewerId
                  nickName:(NSString *)nickName
                  avatar:(NSString *)avatar
                  findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )
{
  NSLog(@"init() - %@ 、 %@ 、 %@ 、 %@、 %@", appId, appSecret, viewerId, nickName, avatar);
  RCTLogInfo(@"init() - %@ 、 %@ 、 %@ 、 %@、 %@", appId, appSecret, viewerId, nickName, avatar);
  
  PolyvLiveWatchRnErrorCode errorCode = PolyvLiveWatchRnError_Success;
  
  if (!appId.length) {
    errorCode = PolyvLiveWatchRnError_NoAppId;
  } else if (!appSecret.length) {
    errorCode = PolyvLiveWatchRnError_NoAppSecret;
  } else if (!viewerId.length) {
    errorCode = PolyvLiveWatchRnError_NoViewerId;
  }
  
  if (errorCode == PolyvLiveWatchRnError_Success) {
    [PLVLiveConfig liveConfigWithAppId:appId appSecret:appSecret];
    [PLVLiveConfig setViewLogParam:viewerId param2:nil param4:nil param5:nil];
    [PLVLiveConfig setLogLevel:k_PLV_LIVE_LOG_ERROR];
    
    self.nickName = nickName ? nickName : @"游客";
    self.avatar = avatar ? avatar : @"";
    
    resolve(@[@(PolyvLiveWatchRnError_Success)]);
  } else {
    NSString *errorDesc = NSStringFromPolyvLiveWatchRnError(errorCode);
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
    NSLog(@"%@", errorDesc);
    reject([@(errorCode) stringValue], errorDesc, error);
  }
}

// 参数 userId (必填)
// 参数 channelId (必填)
RCT_EXPORT_METHOD(
                  login:(nonnull NSNumber *)reactTag
                  userId:(NSString *)userId
                  channelId:(NSString *)channelId
                  findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )
{
  NSLog(@"login() - %@ 、 %@", userId, channelId);
  RCTLogInfo(@"login() - %@ 、 %@", userId, channelId);
  
  PolyvLiveWatchRnErrorCode errorCode = PolyvLiveWatchRnError_Success;

  if (!userId.length) {
    errorCode = PolyvLiveWatchRnError_NoUserId;
  } else if (!channelId.length) {
    errorCode = PolyvLiveWatchRnError_NoChannelId;
  }
  
  if (errorCode == PolyvLiveWatchRnError_Success) {
    
    RCTUIManager *uiManager = _bridge.uiManager;
    dispatch_async(uiManager.methodQueue, ^{
      [uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        UIView *view = viewRegistry[reactTag];
        UIViewController *viewController = (UIViewController *)view.reactViewController;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
        hud.label.text = @"登录中...";
        [PLVLiveAPI loadChannelInfoRepeatedlyWithUserId:userId channelId:channelId.integerValue completion:^(PLVLiveChannel *channel) {
          [hud hideAnimated:YES];
          
          LivePlayerViewController *livePlayerVC = [LivePlayerViewController new];
          livePlayerVC.channel = channel;
          livePlayerVC.nickName = self.nickName;
          livePlayerVC.avatar = self.avatar;
          [viewController presentViewController:livePlayerVC animated:YES completion:nil];
          
          
          resolve(@[@(PolyvLiveWatchRnError_Success)]);
          
        } failure:^(PLVLiveErrorCode errorCode, NSString *description) {
          [hud hideAnimated:YES];
          
          NSString *errorDesc = NSStringFromPolyvLiveWatchRnError(PolyvLiveWatchRnError_ChannelLoginFailed);
          NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:PolyvLiveWatchRnError_ChannelLoginFailed userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
          NSLog(@"%@", errorDesc);
          reject([@(PolyvLiveWatchRnError_ChannelLoginFailed) stringValue], errorDesc, error);
          
        }];
      }];
    });
    
  } else {
    
    NSString *errorDesc = NSStringFromPolyvLiveWatchRnError(errorCode);
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorDesc}];
    NSLog(@"%@", errorDesc);
    reject([@(errorCode) stringValue], errorDesc, error);
    
  }
  
}

@end

