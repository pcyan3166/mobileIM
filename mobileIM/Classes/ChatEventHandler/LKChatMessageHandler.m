//
//  DYChatMessageHandler.m
//  rpchat_Example
//
//  Created by 鄢彭超 on 2023/2/2.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import "LKChatMessageHandler.h"

@implementation LKChatMessageHandler

#pragma mark - DYEventMessageQueue functions

- (BOOL)conformsRecieverProtocol:(id)reciever {
    return [reciever conformsToProtocol:@protocol(ChatMessageEvent)];
}

#pragma mark - ChatMessageEvent functions
- (void)onErrorResponse:(int)errorCode withErrorMsg:(NSString *)errorMsg {
    @synchronized (self.recieverArray) {
        for (id<ChatMessageEvent> reciever in self.recieverArray) {
            [reciever onErrorResponse:errorCode withErrorMsg:errorMsg];
        }
    }
}

- (void)onRecieveMessage:(NSString *)fingerPrintOfProtocal withUserId:(NSString *)userid andContent:(NSString *)dataContent andTypeu:(int)typeu {
    @synchronized (self.recieverArray) {
        for (id<ChatMessageEvent> reciever in self.recieverArray) {
            [reciever onRecieveMessage:fingerPrintOfProtocal withUserId:userid andContent:dataContent andTypeu:typeu];
        }
    }
}

@end
