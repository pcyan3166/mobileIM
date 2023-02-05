//
//  DYStatesEventHandler.m
//  rpchat_Example
//
//  Created by 鄢彭超 on 2023/2/2.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import "LKStatesEventHandler.h"
#import "ErrorCode.h"

@implementation LKStatesEventHandler

#pragma mark - DYEventMessageQueue functions

- (BOOL)conformsRecieverProtocol:(id)reciever {
    return [reciever conformsToProtocol:@protocol(ChatBaseEvent)];
}

#pragma mark - ChatBaseEvent functions

- (void)onKickout:(PKickoutInfo *)kickoutInfo {
    _loginSuccessed = NO;
    
    if (kickoutInfo != nil) {
        @synchronized (self.recieverArray) {
            for (id<ChatBaseEvent> reciever in self.recieverArray) {
                [reciever onKickout:kickoutInfo];
            }
        }
    }
}

- (void)onLinkClose:(int)errorCode {
    _loginSuccessed = NO;
    
    @synchronized (self.recieverArray) {
        for (id<ChatBaseEvent> reciever in self.recieverArray) {
            [reciever onLinkClose:errorCode];
        }
    }
}

- (void)onLoginResponse:(int)errorCode {
    if (errorCode == COMMON_CODE_OK) {
        _loginSuccessed = YES;
    } else {
        _loginSuccessed = NO;
    }
    @synchronized (self.recieverArray) {
        for (id<ChatBaseEvent> reciever in self.recieverArray) {
            [reciever onLoginResponse:errorCode];
        }
    }
}

@end
