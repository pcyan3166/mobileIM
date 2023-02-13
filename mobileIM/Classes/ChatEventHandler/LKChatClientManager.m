//
//  DYChatClientManager.m
//  rpchat_Example
//
//  Created by 鄢彭超 on 2023/2/2.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import "LKChatClientManager.h"
#import "ClientCoreSDK.h"
#import "ConfigEntity.h"
#import "LKStatesEventHandler.h"
#import "LKChatMessageHandler.h"
#import "LKQosEventHandler.h"

@implementation LKChatClientManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static LKChatClientManager *sChatClientManager;
    dispatch_once(&onceToken, ^{
        sChatClientManager = [[LKChatClientManager alloc] init];
    });
    
    return sChatClientManager;
}

- (void)startWithIP:(NSString *)ip andPort:(int)port {
    if (![[ClientCoreSDK sharedInstance] isInitialed]) {
        // 设置AppKey
        [ConfigEntity registerWithAppKey:@"5418023dfd98c579b6001741"];
        
        // 设置服务器ip和服务器端口
        [ConfigEntity setServerIp:ip];
        [ConfigEntity setServerPort:port];
        
        // 使用以下代码表示不绑定固定port（由系统自动分配），否则使用默认的7801端口
//      [ConfigEntity setLocalSendAndListeningPort:-1];
        
        // MobileIMSDK核心IM框架的敏感度模式设置
        [ConfigEntity setSenseMode:SenseMode5S];
        
        // 设置最大TCP帧内容长度（不设置则默认最大是 6 * 1024字节）
//      [TCPFrameCodec setTCP_FRAME_MAX_BODY_LENGTH:60 * 1024];
        
        // 开启DEBUG信息输出
        [ClientCoreSDK setENABLED_DEBUG:YES];
        
        // 设置事件回调
        _statesEventHandler = [[LKStatesEventHandler alloc] init];
        _chatMessageHandler = [[LKChatMessageHandler alloc] init];
        _qosEventHandler = [[LKQosEventHandler alloc] init];
        [ClientCoreSDK sharedInstance].chatBaseEvent = _statesEventHandler;
        [ClientCoreSDK sharedInstance].chatMessageEvent = _chatMessageHandler;
        [ClientCoreSDK sharedInstance].messageQoSEvent = _qosEventHandler;
        
        [[ClientCoreSDK sharedInstance] initCore];
    }
}

- (void)stop {
    [[ClientCoreSDK sharedInstance] releaseCore];
}

- (BOOL)isLoginSuccessed {
    return _statesEventHandler.loginSuccessed;
}

@end
