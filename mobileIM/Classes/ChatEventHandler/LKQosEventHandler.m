//
//  DYQosEventHandler.m
//  rpchat_Example
//
//  Created by 鄢彭超 on 2023/2/2.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import "LKQosEventHandler.h"

@implementation LKQosEventHandler

#pragma mark - DYEventMessageQueue functions

- (BOOL)conformsRecieverProtocol:(id)reciever {
    return [reciever conformsToProtocol:@protocol(MessageQoSEvent)];
}

#pragma mark - MessageQoSEvent functions
- (void)messagesBeReceived:(NSString *)theFingerPrint {
    @synchronized (self.recieverArray) {
        for (id<MessageQoSEvent> reciever in self.recieverArray) {
            [reciever messagesBeReceived:theFingerPrint];
        }
    }
}

- (void)messagesLost:(NSMutableArray *)lostMessages {
    @synchronized (self.recieverArray) {
        for (id<MessageQoSEvent> reciever in self.recieverArray) {
            [reciever messagesLost:lostMessages];
        }
    }
}

@end
