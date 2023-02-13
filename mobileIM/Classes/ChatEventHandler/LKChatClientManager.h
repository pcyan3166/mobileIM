//
//  DYChatClientManager.h
//  rpchat_Example
//
//  Created by 鄢彭超 on 2023/2/2.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKStatesEventHandler;
@class LKChatMessageHandler;
@class LKQosEventHandler;

NS_ASSUME_NONNULL_BEGIN

@interface LKChatClientManager : NSObject

/// 单例
+ (instancetype)shareInstance;

/// 启动服务
- (void)startWithIP:(NSString *)ip andPort:(int)port;

/// 关闭服务
- (void)stop;

/// 当前是否已在登录态
- (BOOL)isLoginSuccessed;

@property (nonatomic, strong, readonly) LKStatesEventHandler *statesEventHandler;
@property (nonatomic, strong, readonly) LKChatMessageHandler *chatMessageHandler;
@property (nonatomic, strong, readonly) LKQosEventHandler *qosEventHandler;

@end

NS_ASSUME_NONNULL_END
