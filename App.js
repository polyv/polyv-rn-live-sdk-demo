/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {NativeModules, Platform, StyleSheet, Dimensions, Text, View, TextInput, Image} from 'react-native';

import {findNodeHandle} from 'react-native';
import PolyvLiveRnModule from './page/PolyvLiveWatch'

const logo = require('./img/poly_live_logo.png');

const {height, width} = Dimensions.get('window');
type Props = {};
export default class App extends Component<Props> {
    constructor(props) {
        super(props);
        this.state = {
            // init
            appId: "",
            appScrect: "",
            viewerId:"rn_viewerId",
            nickName:"rn_nickName",
            avatar:"http://www.polyv.net/images/effect/effect-device.png",

            // Login
            userId: "",
            channelId: "",
        };
    }
    
    componentWillMount(){
        console.log("componentWillMount")
        /**
         * <Polyv Live init/>
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
    }

    render() {
        return (
            <View style={styles.container}>

                <Image style={styles.logo} source={logo}></Image>
                <TextInput placeholder="请输入用户id" style={styles.input}
                           onChangeText={(text) => this.setState({userId: text})}>{this.state.userId}</TextInput>
                <TextInput style={styles.input} placeholder="请输入appid"
                           onChangeText={(text) => this.setState({channelId: text})}>{this.state.channelId}</TextInput>
                <Text style={styles.text} onPress={
                    () => {
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
                    }
                }>登录</Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        display: 'flex',
        flexDirection: 'column',
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    logo: {
        resizeMode: 'contain',
        width: 220,
        height: 110,
    },
    text: {
        textAlign: 'center',
        width: width * 0.8,
        borderRadius: 5,
        justifyContent: 'center',
        alignItems: 'center',
        fontSize: 20,
        height: 50,
        backgroundColor: "#63B8FF",
        margin: 10,
        padding: 10,
    },
    input: {
        width: width * 0.8,
        height: 50,
        backgroundColor: '#ffffff',
        fontSize: 20,
        margin: 10,
        padding: 10,
    },

    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
    match: {
        width: 500,
        height: 500,
    }
});
