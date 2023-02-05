//
//  DYChatMessageHandler.h
//  rpchat_Example
//
//  Created by 鄢彭超 on 2023/2/2.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKEventMessageQueue.h"
#import "ChatMessageEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKChatMessageHandler : LKEventMessageQueue <ChatMessageEvent>

@end

NS_ASSUME_NONNULL_END
