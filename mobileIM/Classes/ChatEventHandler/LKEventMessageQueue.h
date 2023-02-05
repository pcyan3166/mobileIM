//
//  DYEventMessageQueue.h
//  rpchat_Example
//
//  Created by 鄢彭超 on 2023/2/2.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKEventMessageQueue : NSObject

/// 存储消费者的队列
@property (nonatomic, strong, readonly) NSArray *recieverArray;

/// 确认消费者是否签署协议（子类实现）
/// @param reciever 消费者
- (BOOL)conformsRecieverProtocol:(id)reciever;

/// 注册消息消费者
/// @param reciever 消费者
- (BOOL)registerReciever:(id)reciever;

/// 移除消息消费者
/// @param reciever 消费者
- (BOOL)unregisterReciever:(id)reciever;

/// 移除所有消费者
- (void)unregisterAllReciever;

@end

NS_ASSUME_NONNULL_END
