//
//  DYEventMessageQueue.m
//  rpchat_Example
//
//  Created by 鄢彭超 on 2023/2/2.
//  Copyright © 2023 鄢彭超. All rights reserved.
//

#import "LKEventMessageQueue.h"

@interface LKEventMessageQueue ()

@end

@implementation LKEventMessageQueue

- (BOOL)conformsRecieverProtocol:(id)reciever {
    return NO;
}

- (BOOL)registerReciever:(id)reciever {
    if (reciever == nil) {
        return NO;
    }
    
    if (![self conformsRecieverProtocol:reciever]) {
        return NO;
    }
    
    @synchronized (_recieverArray) {
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray:_recieverArray];
        if ([mArray containsObject:reciever]) {
            return NO;
        }
        
        [mArray addObject:reciever];
        _recieverArray = mArray;
    }
    
    return YES;
}

- (BOOL)unregisterReciever:(id)reciever {
    if (reciever == nil) {
        return NO;
    }
    
    @synchronized (_recieverArray) {
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray:_recieverArray];
        if ([mArray containsObject:reciever]) {
            [mArray removeObject:reciever];
            _recieverArray = mArray;
            
            return YES;
        }
    }
    return NO;
}

- (void)unregisterAllReciever {
    _recieverArray = [NSArray array];
}

@end
