package com.easefun.polyvsdk.live.rn;

/**
 * @author df
 * @create 2019/1/26
 * @Describe
 */
public class PolyvLiveErrorCode {
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
    public final static int success = 0;
    public final static int noAppId = -1;
    public final static int noAppScrect = -2;
    public final static int noViewId = -3;
    public final static int noUserId = -4;
    public final static int noChannelId = -5;
    public final static int channleLoadFailed = -6;

    public static String getDesc(int code) {
        switch (code) {
            case PolyvLiveErrorCode.success:
                return "成功";
            case PolyvLiveErrorCode.noAppId:
                return "AppId为空";
            case PolyvLiveErrorCode.noAppScrect:
                return "AppSecret为空";
            case PolyvLiveErrorCode.noViewId:
                return "viewerId为空";
            case PolyvLiveErrorCode.noUserId:
                return "UserId为空";
            case PolyvLiveErrorCode.noChannelId:
                return "ChannelId为空";
            case PolyvLiveErrorCode.channleLoadFailed:
                return "频道加载失败";
            default:
                return "";
        }
    }
}
