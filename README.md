### RN直播集成文档

### 概述

PolyvRNLiveDemo是为ReactNative技术开发者定制的直播集成Demo，展示了登录与直播页面相关的功能。

### 阅读对象

本文档为技术文档，需要阅读者：

- 了解React native技术并准备使用该技术接入直播功能的开发者。

### 开发准备

#### 开发设备及系统

- 设备要求：搭载 Android 、iOS系统的设备
- 系统要求：Android 4.1.0(API 16) 及其以上、iOS：iOS9

#### 前置条件

- 账号要求：需要有polyv官方的直播账号

- 通过官网申请并已开通直播权限


#### 快速开始

#####   React端集成步骤

开始运行行执行如下命令下载react 相关依赖

```js
npm install
```

对应的native端的注册入口标签名为：‘PolyvRNLiveDemo’   对应到app.json文件里的配置

```js
{
  "name": "PolyvRNLiveDemo",
  "displayName": "PolyvRNLiveDemo"
}
```

封装的 JS 文件：PolyvLiveWatch.js。

```javascript
PolyvLiveWatch.js：JS与原生代码的通信模块。
里面封装了了native的初始化以及登录进入播放器界面

//引入方式：
import PolyvLiveRnModule from './page/PolyvLiveWatch'
//数据配置 开发者填入自己相关的账户信息
this.state = {
            appId: "",
            appScrect: "",
            userId: "",
            channelId: "",
            viewerId:"rn_viewerId",
            nickName:"rn_nickName",
            avatar:"http://www.polyv.net/images/effect/effect-device.png",
        };

//初始化
/**
 * <Polyv Live init/>
 * 初始化的方法要放在界面渲染前初始化 一般在componentWillMount 调用该方法进行初始化
 */
console.log("Polyv live init")
PolyvLiveRnModule.init(this.state.appId,this.state.appScrect,this.state.viewerId, this.state.nickName, this.state.avatar)
    .then(ret => {
        if (ret.code != 0) { // 初始化失败
             var str = "初始化失败  errCode=" + ret.code + "  errMsg=" + ret.message
             console.log(str)
             alert(str)
        } else { // 初始化成功
             console.log("初始化成功")
        }
    })


/**
 * <Polyv Live Login/>
 */
console.log("Polyv live login")
PolyvLiveRnModule.login(findNodeHandle(this), this.state.userId, this.state.channelId)
     .then(ret => {
          if (ret.code != 0) { // 加载频道失败
              var str = "加载频道失败  errCode=" + ret.code + "  errMsg=" + ret.message
              console.log(str)
              alert(str)
          } else { // 加载频道成功
              console.log("加载频道成功")
          }
     })

两个方法都提供了返回值，可以使用异步调用的方式获取返回值
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

```

#####    Android端集成步骤

Android端工程由两部分构成，一部分是定制的rn模块，也是工程的主模块（app）；另外是common模块，主要是polyv相关的组件代码文件。

###### 相关依赖配置

用户集成工程需要进行模块项目依赖：setting.gradle

```java
rootProject.name = 'PolyvRNLiveDemo'

include ':app'，':common'
```

工程的相关依赖配置：build.gradle

```java
compile project(path: ':common')
```

######  代码集成

将PolyvLiveRnPackage，PolyvLiveRnModule，PolyvLiveErrorCode文件拷贝到android项目的相关目录下

##### iOS端集成步骤

1. 拷贝相关的Native代码

   拷贝 demo项目的 ios/PolyvLiveWatchRnModule文件夹 到 自身项目的 ios 目录下；

2. 集成CocoaPods管理第三方库

   拷贝 demo项目的 ios/Podfile 文件到自身项目的 ios 目录下；

   打开 Podfile 文件，把其中 ‘test’ 改为 ‘自身项目名’；

   在 ios 目录中打开命令行，执行 pod install 命令；
