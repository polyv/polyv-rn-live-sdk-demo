package com.easefun.polyvsdk.live.rn;

import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import com.easefun.polyvsdk.live.PolyvConstant;
import com.easefun.polyvsdk.live.activity.PolyvLivePlayerActivity;
import com.easefun.polyvsdk.live.permission.PolyvPermission;
import com.easefun.polyvsdk.live.PolyvLiveSDKClient;
import com.easefun.polyvsdk.live.chat.PolyvChatManager;
import com.easefun.polyvsdk.live.chat.linkmic.module.PolyvLinkMicManager;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;

/**
 * @author df
 * @create 2019/1/9
 * @Describe
 */
public class PolyvLiveRnModule extends ReactContextBaseJavaModule {

    private static final String TAG = "PolyvLiveRnModule";

    private PolyvPermission polyvPermission;
    private String userId;
    private String channelId;
    // 登录聊天室的昵称
    private String nickName = "游客" + Build.SERIAL;
    // chatUserId可以使用学员的Id代替(注：相同的chatUserId不能相互接收对方的信息)
    private String chatUserId = Build.SERIAL;

    public PolyvLiveRnModule(ReactApplicationContext reactContext) {
        super(reactContext);
        polyvPermission = new PolyvPermission();
        polyvPermission.setResponseCallback(new PolyvPermission.ResponseCallback() {
            @Override
            public void callback() {
                gotoPlay(getCurrentActivity());
            }
        });
    }

    @Override
    public String getName() {
        return "PolyvLiveRnModule";
    }

    @ReactMethod
    public void init(String appId, String appSecrect, String viewerId, String nickName, String avatar,Promise promise){

        int code = PolyvLiveErrorCode.success;

        if(TextUtils.isEmpty(appId)){
            code = PolyvLiveErrorCode.noAppId;
        } else if(TextUtils.isEmpty(appSecrect)){
            code = PolyvLiveErrorCode.noAppScrect;
        } else if(TextUtils.isEmpty(viewerId)){
            code = PolyvLiveErrorCode.noViewId;
        }

        if (code == PolyvLiveErrorCode.success) {
            Log.d(TAG, "init: ");
            PolyvConstant.appId = appId;
            PolyvConstant.appSecret = appSecrect;
            PolyvConstant.viewerId = viewerId;
            PolyvConstant.nickName = nickName;
            PolyvConstant.avatar = avatar;

            // 创建默认的ImageLoader配置参数
            ImageLoaderConfiguration configuration = ImageLoaderConfiguration.createDefault(getCurrentActivity());
            // Initialize ImageLoader with configuration.
            ImageLoader.getInstance().init(configuration);

            // 初始化实例
            PolyvLiveSDKClient.getInstance();
            // 初始化聊天室配置
            PolyvChatManager.initConfig(appId, appSecrect);
            // appid
            PolyvLinkMicManager.init(getCurrentActivity());

            WritableMap map = Arguments.createMap();
            map.putInt("code", PolyvLiveErrorCode.success);
            promise.resolve(map);
        } else {
            String errorCode = "" + code;
            String errorDesc = PolyvLiveErrorCode.getDesc(code);
            Throwable throwable = new Throwable(errorDesc);
            Log.e(TAG, "errorCode=" + errorCode + "  errorDesc=" + errorDesc);
            promise.reject(errorCode, errorDesc, throwable);
        }


    }

    @ReactMethod
    public void login(Integer handler, String userId, String channelId, Promise promise)
    {
        int code = PolyvLiveErrorCode.success;
        if (TextUtils.isEmpty(userId)) {
            code = PolyvLiveErrorCode.noUserId;
        } else if (TextUtils.isEmpty(channelId)) {
            code = PolyvLiveErrorCode.noChannelId;
        }

        if (code == PolyvLiveErrorCode.success) {
            this.userId = userId;
            this.channelId = channelId;

            polyvPermission.applyPermission(getCurrentActivity(), PolyvPermission.OperationType.play);

            WritableMap map = Arguments.createMap();
            map.putInt("code", PolyvLiveErrorCode.success);
            promise.resolve(map);
        } else {
            String errorCode = "" + code;
            String errorDesc = PolyvLiveErrorCode.getDesc(code);
            Throwable throwable = new Throwable(errorDesc);
            Log.e(TAG, "errorCode=" + errorCode + "  errorDesc=" + errorDesc);
            promise.reject(errorCode, errorDesc, throwable);
        }
    }

    private void gotoPlay(Context context) {
        context.startActivity(PolyvLivePlayerActivity.newIntent(context, userId, channelId, chatUserId, PolyvConstant.nickName, false, false));
    }
}
