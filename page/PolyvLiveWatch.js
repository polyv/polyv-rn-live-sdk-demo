'use strict';

import { NativeModules } from 'react-native';

/**
 * code，返回码定义：
 *      0  成功
 *      -1 AppId为空
 *      -2 AppSecret为空
 *      -3 viewerId为空
 *      -4 UserId为空
 *      -5 ChannelId为空
 *      -6 频道加载失败
 */

const PolyvLiveRnModule = {
    //初始化
    async init (appId, appScrect, viewerId, nickName, avatar){
        console.log("init_{appId}_{appScrect}")
        try {
            await NativeModules.PolyvLiveRnModule.init(appId, appScrect, viewerId, nickName, avatar)
            return { "code":0 }
        } catch (e) {
            var code = e.code;
            var message = e.message;
            return { code, message }
        }
    },
    
    //加载频道
    async login(handler, userId, channelId){
        console.log("login_{userId}_{channelId}")
        try {
            await NativeModules.PolyvLiveRnModule.login(handler, userId, channelId)
            return { "code":0 }
        } catch (e) {
            var code = e.code;
            var message = e.message;
            return { code, message }
        }
    }
};

module.exports = PolyvLiveRnModule;
