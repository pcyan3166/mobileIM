//
//  DYStatesEventHandler.h
//  rpchat_Example
//
//  Created by 鄢彭超 on 2023/2/2.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKEventMessageQueue.h"
#import "ChatBaseEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKStatesEventHandler : LKEventMessageQueue <ChatBaseEvent>

/// 当前登录状态：YES为已登录，NO为未登录、被踢出或断开连接
@property (nonatomic, assign) BOOL loginSuccessed;

@end

NS_ASSUME_NONNULL_END
